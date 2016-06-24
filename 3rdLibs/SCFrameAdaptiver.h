//
//  SCFrameAdaptiver.h
//  SecretChat
//
//  Created by Patrick.Coin on 14/12/11.
//  Copyright (c) 2014年 Patrick.Coin. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef SecretChat_SCFrameAdaptiver_h
#define SecretChat_SCFrameAdaptiver_h

CG_INLINE CGFloat SCFixHeightFlaot(CGFloat height) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return height;
    }
    height = height*mainFrme.size.height/1096*2;
    return height;
}

CG_INLINE CGFloat SCReHeightFlaot(CGFloat height) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return height;
    }
    height = height*1096/(mainFrme.size.height*2);
    return height;
}

CG_INLINE CGFloat SCFixWidthFlaot(CGFloat width) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return width;
    }
    width = width*mainFrme.size.width/640*2;
    return width;
}

CG_INLINE CGFloat SCReWidthFlaot(CGFloat width) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return width;
    }
    width = width*640/mainFrme.size.width/2;
    return width;
}

CG_INLINE CGRect
SCRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x; rect.origin.y = y;
    rect.size.width = SCFixWidthFlaot(width);
    rect.size.height = SCFixWidthFlaot(height);
    return rect;
}

#endif
