//
//  ZJTGlobal.m
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import "ZJTGlobal.h"

@implementation ZJTGlobal

+(instancetype)sharedIncetance
{
    static ZJTGlobal *incetance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        incetance = [[ZJTGlobal alloc] init];
    });
    
    return incetance;
}

@end
