//
//  ZJTPageControl.m
//  掌上服饰
//
//  Created by Patrick Zhu on 13-9-22.
//  Copyright (c) 2013年 Patrick Zhu. All rights reserved.
//

#import "ZJTPageControl.h"
@interface ZJTPageControl()
{
    CGSize _itemSize;
    UIImage *_normalImage;
    UIImage *_selectedImage;
}

@end

@implementation ZJTPageControl

- (id)initWithFrame:(CGRect)frame count:(int)count
          itemSize:(CGSize)itemSize
        normalImage:(UIImage*)normalImage
      selectedImage:(UIImage*)selectedImage
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfPages = count;
        _itemSize = itemSize;
        _selectedImage = selectedImage;
        _normalImage = normalImage;
        
        _pages = [NSMutableArray new];
        _currentPage = 0;
        [self refresh];
    }
    return self;
}

-(void)relayout
{
    for (UIView *view in _pages)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    [_pages removeAllObjects];
    
    for (int i = 0; i < _numberOfPages; i++)
    {
         int btwn = 12;
         UIImageView * item = [[UIImageView alloc] initWithFrame:CGRectMake((ZJT_ViewWidth - 9 * _numberOfPages - btwn *(_numberOfPages - 1)) / 2 + i * (9 + btwn),
                                                                           0,
                                                                           9,
                                                                           9)];
//        CGFloat padding = (w - iW * _numberOfPages) / (_numberOfPages + 1);
//        UIImageView *item = [[UIImageView alloc] initWithFrame:CGRectMake(
//                                                                          padding * (i + 1) + iW * i,
//                                                                          (h - iH) / 2.0,
//                                                                          iW,
//                                                                          iH
//                                                                          )];
        
        [_pages addObject:item];
        [self addSubview:item];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)refresh
{
    [self relayout];
    for (int i = 0; i < _numberOfPages; i++)
    {
        UIImageView *item = _pages[i];
        
        if (i == _currentPage)
        {
            item.image = _selectedImage;
        }
        else
        {
            item.image = _normalImage;
        }
    }
}

-(void)setCurrentPage:(int)currentPage
{
    if (currentPage != _currentPage)
    {
        _currentPage = currentPage;
        [self refresh];
    }
}

-(void)refreshCount:(int)count
          itemSize:(CGSize)itemSize
        normalImage:(UIImage*)normalImage
      selectedImage:(UIImage*)selectedImage
{
    _numberOfPages = count;
    if (itemSize.height != 0)
    {
        _itemSize = itemSize;
    }
    
    _selectedImage = selectedImage;
    
    _normalImage = normalImage;
    
    [self refresh];
}

@end
