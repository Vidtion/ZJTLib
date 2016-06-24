//
//  UIBlockAlertView.h
//  KMMallIOS
//
//  Created by Patrick Zhu on 14-2-21.
//  Copyright (c) 2014年 Patrick Zhu All rights reserved.
//

#import <UIKit/UIKit.h>

//带block的AlertView
typedef void (^VoidBlock)(void);

@interface ZJTBlockAlertView : UIAlertView
{
    
}

@property(nonatomic,copy)  VoidBlock cancelBlock;
@property(nonatomic,copy)  VoidBlock okBlock;
@property (nonatomic,readonly) BOOL isShowing;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
     okButtonTitles:(NSString *)okButtonTitles;

@end
