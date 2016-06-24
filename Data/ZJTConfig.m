//
//  ZJTConfig.m
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import "ZJTConfig.h"

@implementation ZJTConfig

+(instancetype)sharedIncetance
{
    static ZJTConfig *incetance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        incetance = [[ZJTConfig alloc] init];
    });
    
    return incetance;
}
@end
