//
//  UIView+ZJTLib.h
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZJTLib)

#pragma mark - FrameExpand
/**
 *  @author PatrickCoin, 2015-09-16 12:09:16
 *
 *  FrameExpand
 */
@property CGFloat zHeight;
@property CGFloat zWidth;

@property CGFloat zTop;
@property CGFloat zLeft;

@property CGFloat zBottom;
@property CGFloat zRight;

@property CGFloat zCenterX;
@property CGFloat zCenterY;

/**
 *  @author PatrickCoin, 2015-09-16 14:09:07
 *
 *  添加圆角
 */
-(void)zjt_roundCornerRadius:(CGFloat)cornerRadius;

-(void)zjt_roundCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor*)borderColor;

-(void)zjt_roundCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  @author PatrickCoin, 2015-09-16 14:09:24
 *
 *  添加点击时间响应
 */
-(void)zjt_addTapWithTarget:(id)target
                 action:(SEL)action;

@end
