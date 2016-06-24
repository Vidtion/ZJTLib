//
//  ZJTEntity.m
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import "ZJTEntity.h"

#define TheID @"datasIdentifier"

@implementation ZJTEntity

+ (void)initialize
{
    if (self != [ZJTEntity self]) {
        [self createTable];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _columeNames = [self.class columeNames];
        _columeTypes = [self.class columeTypes];
        
        self.modelUpdateTime = @([[NSDate date] timeIntervalSince1970]);
        self.modelCreateTime = @([[NSDate date] timeIntervalSince1970]);
    }
    
    return self;
}

+(NSString*)primaryKey
{
    return @"datasIdentifier";
}

+(NSString*)tableName
{
    NSString *tableName = NSStringFromClass(self);
    return tableName;
}

+(NSDictionary*)propertyDict
{
    return @{@"modelUpdateTime":@"REAL",
             @"modelCreateTime":@"REAL",
             };
}

+(NSString*)propertyListString
{
    NSDictionary *dict = [self propertyDict];
    if (dict) {
        NSMutableString *properties = [NSMutableString string];
        for (NSString *key in dict.allKeys) {
            [properties appendFormat:@"%@ %@,",key,dict[key]];
        }
        
        if ([properties hasSuffix:@","] && properties.length > 2) {
            NSUInteger index = properties.length;
            properties = (NSMutableString*)[properties substringToIndex:index - 1];
        }
        
        return properties;
    }
    
    return nil;
}

+(NSArray*)columeNames
{
    NSMutableArray *columeNames = [self.class propertyDict].allKeys.mutableCopy;
   [columeNames addObject:TheID];
    return columeNames;
}

+(NSArray*)columeTypes
{
    NSMutableArray *columeTypes = [NSMutableArray array];
    NSDictionary *dict = [self.class propertyDict];
    NSArray *columeNames = [self.class columeNames];
    for (NSString *key in columeNames) {
        id value = dict[key];
        if ([key isEqualToString:TheID]) {
            value = SQLiteType_Text;
        }
        [columeTypes addObject:value];
    }
    return columeTypes;
}

+(NSString*)createSQL
{
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ CHAR(36) PRIMARY KEY NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'",[self tableName],[self primaryKey]];
    if ([self propertyListString]) {
        [sql appendFormat:@",%@);",[self propertyListString]];
    }
    else
    {
        [sql appendString:@");"];
    }
    return sql;
}

+(BOOL)createTable
{
    __block BOOL res = YES;
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    NSString *sql = [self createSQL];
    NSLog(@"sql = %@",sql);
    
    /**
     *  处理事务
     */
    [manager.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         //创建失败,撤销操作
         if ([db executeUpdate:sql] == NO) {
             res = NO;
             *rollback = YES;
             return;
         };
         
         NSMutableArray *columns = [NSMutableArray array];
         FMResultSet *resultSet = [db getTableSchema:[self tableName]];
         while ([resultSet next]) {
             NSString *column = [resultSet stringForColumn:@"name"];
             [columns addObject:column];
         }
         NSDictionary *dict = [self propertyDict];
         NSArray *properties = [dict allKeys];
         NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",columns];
         
         //过滤数组
         NSArray *resultArray = [properties filteredArrayUsingPredicate:filterPredicate];
         for (NSString *column in resultArray) {
             NSString *proType = [dict objectForKey:column];
             NSString *fieldSql = [NSString stringWithFormat:@"%@ %@",column,proType];
             NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ ",[self tableName],fieldSql];
             if (DebugLog) {
                 NSLog(@"ALTER TABLE sql = %@\n",sql);
             }
             if (![db executeUpdate:sql]) {
                 res = NO;
                 *rollback = YES;
                 return ;
             }
         }
     }];
    
    return res;
}

/** 数据库中是否存在表 */
+ (BOOL)isExistInTable
{
    __block BOOL res = NO;
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    [manager.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [self tableName];
        res = [db tableExists:tableName];
    }];
    return res;
}

/** 获取列名 */
+ (NSArray *)getColumns
{
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    NSMutableArray *columns = [NSMutableArray array];
    [manager.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [self tableName];
        FMResultSet *resultSet = [db getTableSchema:tableName];
        while ([resultSet next]) {
            NSString *column = [resultSet stringForColumn:@"name"];
            [columns addObject:column];
        }
    }];
    return [columns copy];
}

- (BOOL)save
{
    id primaryValue = [self valueForKey:TheID];
    id obj = [self.class findByPK:primaryValue];
    if (obj == nil) {
        return [self insert];
    }
    
    return [self update];
}

- (BOOL)insert
{
    NSString *tableName = [self.class tableName];
    NSMutableString *keyString = [NSMutableString string];
    NSMutableString *valueString = [NSMutableString string];
    NSMutableArray *insertValues = [NSMutableArray  array];
    NSArray *columeNames = [self.class columeNames];
    for (int i = 0; i < columeNames.count; i++) {
        NSString *proname = [columeNames objectAtIndex:i];

        [keyString appendFormat:@"%@,", proname];
        [valueString appendString:@"?,"];
        id value = [self valueForKey:proname];
        if (!value) {
            value = @"";
        }
        [insertValues addObject:value];
    }
    
    [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
    [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
    
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    __block BOOL res = NO;
    [manager.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
        res = [db executeUpdate:sql withArgumentsInArray:insertValues];
        if (DebugLog) {
            NSLog(res?@"插入成功":@"插入失败");
            NSLog(@"sql = %@\n",sql);
        }
    }];
    return res;
}

/** 批量保存用户对象 */
+ (BOOL)insertObjects:(NSArray *)array
{
    //判断是否是JKBaseModel的子类
    for (ZJTEntity *model in array) {
        if (![model isKindOfClass:[ZJTEntity class]]) {
            return NO;
        }
    }
    
    __block BOOL res = YES;
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    // 如果要支持事务
    [manager.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (ZJTEntity *model in array) {
            NSString *tableName = NSStringFromClass(model.class);
            NSMutableString *keyString = [NSMutableString string];
            NSMutableString *valueString = [NSMutableString string];
            NSMutableArray *insertValues = [NSMutableArray  array];
            
            for (int i = 0; i < model.columeNames.count; i++) {
                NSString *proname = [model.columeNames objectAtIndex:i];
//                if ([proname isEqualToString:TheID]) {
//                    continue;
//                }
                [keyString appendFormat:@"%@,", proname];
                [valueString appendString:@"?,"];
                id value = [model valueForKey:proname];
                if (!value) {
                    value = @"";
                }
                [insertValues addObject:value];
            }
            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
            [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
            
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:insertValues];
//            model.pk = flag?[NSNumber numberWithLongLong:db.lastInsertRowId].intValue:0;
            if (DebugLog) {
                NSLog(flag?@"插入成功":@"插入失败");
                NSLog(@"sql = %@\n",sql);
            }
            
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    return res;
}

/** 更新单个对象 */
- (BOOL)update
{
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    __block BOOL res = NO;
    self.modelUpdateTime = @([[NSDate date] timeIntervalSince1970]);
    [manager.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        id primaryValue = [self valueForKey:TheID];
//        if (!primaryValue || primaryValue <= 0) {
//            return ;
//        }
        NSMutableString *keyString = [NSMutableString string];
        NSMutableArray *updateValues = [NSMutableArray  array];
        for (int i = 0; i < self.columeNames.count; i++) {
            NSString *proname = [self.columeNames objectAtIndex:i];
//            if ([proname isEqualToString:TheID]) {
//                continue;
//            }
            [keyString appendFormat:@" %@=?,", proname];
            id value = [self valueForKey:proname];
            if (!value) {
                value = @"";
            }
            [updateValues addObject:value];
        }
        
        //删除最后那个逗号
        [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ?;", tableName, keyString, TheID];
        [updateValues addObject:primaryValue];
        res = [db executeUpdate:sql withArgumentsInArray:updateValues];
        
        if (DebugLog) {
            NSLog(res?@"更新成功":@"更新失败");
            NSLog(@"sql = %@\n",sql);
        }
    }];
    return res;
}

/** 批量更新用户对象*/
+ (BOOL)updateObjects:(NSArray *)array
{
    for (ZJTEntity *model in array) {
        if (![model isKindOfClass:[ZJTEntity class]]) {
            return NO;
        }
    }
    __block BOOL res = YES;
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    // 如果要支持事务
    [manager.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (ZJTEntity *model in array) {
            
            model.modelUpdateTime = @([[NSDate date] timeIntervalSince1970]);
            
            NSString *tableName = NSStringFromClass(model.class);
            id primaryValue = [model valueForKey:TheID];
//            if (!primaryValue || primaryValue <= 0) {
//                res = NO;
//                *rollback = YES;
//                return;
//            }
            
            NSMutableString *keyString = [NSMutableString string];
            NSMutableArray *updateValues = [NSMutableArray  array];
            for (int i = 0; i < model.columeNames.count; i++) {
                NSString *proname = [model.columeNames objectAtIndex:i];
//                if ([proname isEqualToString:TheID]) {
//                    continue;
//                }
                [keyString appendFormat:@" %@=?,", proname];
                id value = [model valueForKey:proname];
                if (!value) {
                    value = @"";
                }
                [updateValues addObject:value];
            }
            
            //删除最后那个逗号
            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@=?;", tableName, keyString, TheID];
            [updateValues addObject:primaryValue];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:updateValues];
            
            if (DebugLog) {
                NSLog(flag?@"更新成功":@"更新失败");
                NSLog(@"sql = %@\n",sql);
            }
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    
    return res;
}

/** 删除单个对象 */
- (BOOL)deleteObject
{
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    __block BOOL res = NO;
    [manager.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        id primaryValue = [self valueForKey:TheID];
//        if (!primaryValue || primaryValue <= 0) {
//            return ;
//        }
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,TheID];
        res = [db executeUpdate:sql withArgumentsInArray:@[primaryValue]];
        
        if (DebugLog) {
            NSLog(res?@"删除成功":@"删除失败");
            NSLog(@"sql = %@\n",sql);
        }
    }];
    return res;
}

/** 批量删除用户对象 */
+ (BOOL)deleteObjects:(NSArray *)array
{
    for (ZJTEntity *model in array) {
        if (![model isKindOfClass:[ZJTEntity class]]) {
            return NO;
        }
    }
    
    __block BOOL res = YES;
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    // 如果要支持事务
    [manager.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (ZJTEntity *model in array) {
            NSString *tableName = NSStringFromClass(model.class);
            id primaryValue = [model valueForKey:TheID];
//            if (!primaryValue || primaryValue <= 0) {
//                return ;
//            }
            
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,TheID];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:@[primaryValue]];
            
            if (DebugLog) {
                NSLog(flag?@"删除成功":@"删除失败");
                NSLog(@"sql = %@\n",sql);
            }
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    return res;
}

/** 通过条件删除数据 */
+ (BOOL)deleteObjectsByCriteria:(NSString *)criteria
{
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    __block BOOL res = NO;
    [manager.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@ ",tableName,criteria];
        res = [db executeUpdate:sql];
        
        if (DebugLog) {
            NSLog(res?@"删除成功":@"删除失败");
            NSLog(@"sql = %@\n",sql);
        }
    }];
    return res;
}

/** 通过条件删除 (多参数）--2 */
+ (BOOL)deleteObjectsWithFormat:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *criteria = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    
    return [self deleteObjectsByCriteria:criteria];
}

/** 清空表 */
+ (BOOL)clearTable
{
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    __block BOOL res = NO;
    [manager.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
        res = [db executeUpdate:sql];
       
        if (DebugLog) {
            NSLog(res?@"清空成功":@"清空失败");
            NSLog(@"sql = %@\n",sql);
        }
    }];
    return res;
}

/** 查询全部数据 */
+ (NSArray *)findAll
{
    NSLog(@"manager---%s",__func__);
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    NSMutableArray *users = [NSMutableArray array];
    [manager.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        if (DebugLog) {
            NSLog(@"findAll sql = %@\n",sql);
        }
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            ZJTEntity *model = [[self.class alloc] init];
            for (int i=0; i< model.columeNames.count; i++) {
                NSString *columeName = [model.columeNames objectAtIndex:i];
                NSString *columeType = [model.columeTypes objectAtIndex:i];
                if ([columeType isEqualToString:SQLiteType_Text]) {
                    [model setValue:[resultSet stringForColumn:columeName] forKey:columeName];
                }
                else if ([columeType isEqualToString:SQLiteType_REAL]) {
                    [model setValue:[NSNumber numberWithDouble:[resultSet doubleForColumn:columeName]] forKey:columeName];
                }
                else if ([columeType isEqualToString:SQLiteType_BLOB]) {
                    [model setValue:[NSNumber numberWithBool:[resultSet boolForColumn:columeName]] forKey:columeName];
                }
                else {
                    [model setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columeName]] forKey:columeName];
                }
            }
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    
    return users;
}

+ (instancetype)findFirstWithFormat:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *criteria = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    
    return [self findFirstByCriteria:criteria];
}

/** 查找某条数据 */
+ (instancetype)findFirstByCriteria:(NSString *)criteria
{
    NSArray *results = [self.class findByCriteria:criteria];
    if (results.count < 1) {
        return nil;
    }
    
    return [results firstObject];
}

+ (instancetype)findByPK:(NSString*)theId
{
    NSString *condition = [NSString stringWithFormat:@"WHERE %@='%@'",TheID,theId];
    return [self findFirstByCriteria:condition];
}

+ (NSArray *)findWithFormat:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *criteria = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    
    return [self findByCriteria:criteria];
}

/** 通过条件查找数据 */
+ (NSArray *)findByCriteria:(NSString *)criteria
{
    ZJTDatabaseManager *manager = [ZJTDatabaseManager shareInstance];
    NSMutableArray *users = [NSMutableArray array];
    [manager.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName,criteria];
        if (DebugLog) {
            NSLog(@"findByCriteria sql = %@\n",sql);
        }
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            ZJTEntity *model = [[self.class alloc] init];
            for (int i=0; i< model.columeNames.count; i++) {
                NSString *columeName = [model.columeNames objectAtIndex:i];
                NSString *columeType = [model.columeTypes objectAtIndex:i];
                if ([columeType isEqualToString:SQLiteType_Text]) {
                    [model setValue:[resultSet stringForColumn:columeName] forKey:columeName];
                }
                else if ([columeType isEqualToString:SQLiteType_REAL]) {
                    [model setValue:[NSNumber numberWithDouble:[resultSet doubleForColumn:columeName]] forKey:columeName];
                }
                else if ([columeType isEqualToString:SQLiteType_BLOB]) {
                    [model setValue:[NSNumber numberWithBool:[resultSet boolForColumn:columeName]] forKey:columeName];
                }
                else {
                    [model setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columeName]] forKey:columeName];
                }
            }
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    
    return users;
}

#pragma mark - util method
+ (NSString *)getColumeAndTypeString
{
    NSMutableString* pars = [NSMutableString string];
    NSDictionary *dict = [self.class propertyDict];
    
    NSArray *proNames = [dict allKeys];
    NSArray *proTypes = [dict allValues];
    
    for (int i=0; i< proNames.count; i++) {
        [pars appendFormat:@"%@ %@",[proNames objectAtIndex:i],[proTypes objectAtIndex:i]];
        if(i+1 != proNames.count)
        {
            [pars appendString:@","];
        }
    }
    return pars;
}


@end
