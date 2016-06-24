//
//  ZJTBlockActionSheet.h
//  ZhiHuClient
//
//  Created by Patrick.Coin on 14-9-18.
//  Copyright (c) 2014年 Patrick.Coin. All rights reserved.
//

#import <UIKit/UIKit.h>

//带block的ActionSheet

typedef void (^ZJTBlockActionSheetClickBlock)(NSInteger index ,NSString *title);

@interface ZJTBlockActionSheet : UIActionSheet<UIActionSheetDelegate>
{
    
}

@property(nonatomic,copy)  ZJT_VoidBlock cancelBlock;
@property(nonatomic,copy)  ZJTBlockActionSheetClickBlock clickBlock;

- (id)initWithTitle:(NSString *)title
  otherButtonTitles:(NSArray*)otherButtonTitles;

@end
