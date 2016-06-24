//
//  UIView+ZJTLib.m
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import "UIView+ZJTLib.h"

@implementation UIView (ZJTLib)

#pragma mark - FrameExpand
/**
 *  @author PatrickCoin, 2015-09-16 12:09:26
 *
 *  FrameExpand
 */
- (CGFloat) zHeight
{
    return self.frame.size.height;
}

- (void) setZHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) zWidth
{
    return self.frame.size.width;
}

- (void) setZWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) zTop
{
    return self.frame.origin.y;
}

- (void) setZTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) zLeft
{
    return self.frame.origin.x;
}

- (void) setZLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) zBottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setZBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) zRight
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setZRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (CGFloat) zCenterX
{
    return self.center.x;
}

- (void) setZCenterX: (CGFloat) newCx
{
    self.center = CGPointMake(newCx, self.center.y);
}

- (CGFloat) zCenterY
{
    return self.center.y;
}

- (void) setZCenterY: (CGFloat) newCy
{
    self.center = CGPointMake(self.center.x , newCy);
}

-(void)zjt_roundCornerRadius:(CGFloat)cornerRadius
{
    [self zjt_roundCornerRadius:cornerRadius borderColor:[UIColor colorWithWhite:0.801 alpha:1.000] borderWidth:1];
}

-(void)zjt_roundCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor*)borderColor
{
    [self zjt_roundCornerRadius:cornerRadius borderColor:borderColor borderWidth:0.5];
}

-(void)zjt_roundCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}

-(void)zjt_addTapWithTarget:(id)target
                 action:(SEL)action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

@end
