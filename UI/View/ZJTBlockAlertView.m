//
//  UIBlockAlertView.m
//  KMMallIOS
//
//  Created by Patrick Zhu on 14-2-21.
//  Copyright (c) 2014年 Patrick Zhu All rights reserved.
//

#import "ZJTBlockAlertView.h"

@implementation ZJTBlockAlertView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
     okButtonTitles:(NSString *)okButtonTitles
{
    self = [super initWithTitle:title
                        message:message
                       delegate:self
              cancelButtonTitle:cancelButtonTitle
              otherButtonTitles:okButtonTitles, nil];
    if (self)
    {
        
    }
    return self;
}

-(void)show
{
    [super show];
    _isShowing = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _isShowing = NO;
    
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        if (self.cancelBlock)
        {
            self.cancelBlock();
        }
    }
    else
    {
        if (self.okBlock)
        {
            self.okBlock();
        }
    }
}


@end
