//
//  ZJTPageControl.h
//  掌上服饰
//
//  Created by Patrick Zhu on 13-9-22.
//  Copyright (c) 2013年 Patrick Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  广告位上的红色pageControl
 */
@interface ZJTPageControl : UIView
{
    
}

@property (nonatomic,retain) NSMutableArray *pages;//UIImageView
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) int numberOfPages;

- (id)initWithFrame:(CGRect)frame
              count:(int)count
          itemSize:(CGSize)itemSize
        normalImage:(UIImage*)normalImage
      selectedImage:(UIImage*)selectedImage;

-(void)refresh;

-(void)refreshCount:(int)count
          itemSize:(CGSize)itemSize
        normalImage:(UIImage*)normalImage
      selectedImage:(UIImage*)selectedImage;

@end
