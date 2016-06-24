//
//  ZJTDatabaseManager.h
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface ZJTDatabaseManager : NSObject

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (ZJTDatabaseManager *)shareInstance;

+ (NSString *)dbPath;

- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName;

@end
