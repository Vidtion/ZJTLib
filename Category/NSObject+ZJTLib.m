//
//  NSObject+ZJTLib.m
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import "NSObject+ZJTLib.h"

@implementation NSObject (ZJTLib)

- (id)zjt_performSelector:(SEL)selector withObjects:(NSArray *)objects
{
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    if (signature)
    {
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        for(int i = 0; i < [objects count]; i++)
        {
            id object = [objects objectAtIndex:i];
            [invocation setArgument:&object atIndex: (i + 2)];
        }
        [invocation invoke];
        
        if (signature.methodReturnLength)
        {
            id anObject;
            [invocation getReturnValue:&anObject];
            return anObject;
        }
        
        else
        {
            return nil;
        }
    }
    
    else
    {
        return nil;
    }
}

@end
