//
//  NSObject+ZJTLib.h
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZJTLib)

/**
 *  @author PatrickCoin, 2015-09-22 10:09:44
 *
 *  支持多个参数的performSelector
 */
- (id)zjt_performSelector:(SEL)selector withObjects:(NSArray *)objects;

@end















