//
//  ZJTBlockActionSheet.m
//  ZhiHuClient
//
//  Created by Patrick.Coin on 14-9-18.
//  Copyright (c) 2014年 Patrick.Coin. All rights reserved.
//

#import "ZJTBlockActionSheet.h"

@implementation ZJTBlockActionSheet

- (id)initWithTitle:(NSString *)title
  otherButtonTitles:(NSArray *)otherButtonTitles
{
    self = [super initWithTitle:title
                       delegate:self
              cancelButtonTitle:nil
         destructiveButtonTitle:nil
              otherButtonTitles:nil];
    
    if (self)
    {
        if (ZJT_isArrayValid(otherButtonTitles))
        {
            for (NSString *title in otherButtonTitles)
            {
                [self addButtonWithTitle:title];
            }
            [self addButtonWithTitle:@"取消"];
            self.cancelButtonIndex = otherButtonTitles.count;
        }
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [ZJTSingleton getSingleton].showingActionSheet = nil;
    if (self.clickBlock)
    {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        self.clickBlock(buttonIndex,title);
    }
}

@end
