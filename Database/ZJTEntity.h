//
//  ZJTEntity.h
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SQLiteType_NULL     @"NULL"
#define SQLiteType_INTEGER  @"INTEGER"
#define SQLiteType_REAL     @"REAL"
#define SQLiteType_Text     @"TEXT"
#define SQLiteType_BLOB     @"BLOB"

#define DebugLog 1

@interface ZJTEntity : NSObject

@property (retain, readonly, nonatomic) NSArray *columeNames;
@property (retain, readonly, nonatomic) NSArray *columeTypes;

@property (nonatomic,strong) NSNumber *modelCreateTime;
@property (nonatomic,strong) NSNumber *modelUpdateTime;
@property (nonatomic,strong) NSString* datasIdentifier;

+(NSString*)primaryKey;

+(NSString*)tableName;

+(NSDictionary*)propertyDict;

+(NSString*)propertyListString;

+(NSString*)createSQL;

+(BOOL)createTable;

/** 保存或更新
 * 如果不存在主键，保存，
 * 有主键，则更新
 */
- (BOOL)save;

/** 保存单个数据 */
- (BOOL)insert;
/** 批量保存数据 */
+ (BOOL)insertObjects:(NSArray *)array;
/** 更新单个数据 */
- (BOOL)update;
/** 批量更新数据*/
+ (BOOL)updateObjects:(NSArray *)array;
/** 删除单个数据 */
- (BOOL)deleteObject;
/** 批量删除数据 */
+ (BOOL)deleteObjects:(NSArray *)array;
/** 通过条件删除数据 */
+ (BOOL)deleteObjectsByCriteria:(NSString *)criteria;
/** 通过条件删除 (多参数）--2 */
+ (BOOL)deleteObjectsWithFormat:(NSString *)format, ...;
/** 清空表 */
+ (BOOL)clearTable;

/** 查询全部数据 */
+ (NSArray *)findAll;

/** 通过主键查询 */
+ (instancetype)findByPK:(NSString*)inPk;

+ (instancetype)findFirstWithFormat:(NSString *)format, ...;

/** 查找某条数据 */
+ (instancetype)findFirstByCriteria:(NSString *)criteria;

+ (NSArray *)findWithFormat:(NSString *)format, ...;

/** 通过条件查找数据
 * 这样可以进行分页查询 @" WHERE pk > 5 limit 10"
 */
+ (NSArray *)findByCriteria:(NSString *)criteria;


@end
