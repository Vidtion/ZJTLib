//
//  NSData+ZJTLib.m
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import "NSData+ZJTLib.h"

@implementation NSData (ZJTLib)

-(BOOL)isValidJPEG
{
    if (!self || self.length < 2) return NO;
    
    NSInteger totalBytes = self.length;
    const char *bytes = (const char*)[self bytes];
   
    BOOL isValid = (bytes[0] == (char)0xff &&
                    bytes[1] == (char)0xd8 &&
                    bytes[totalBytes-2] == (char)0xff &&
                    bytes[totalBytes-1] == (char)0xd9);
    
    return isValid;
}

@end
