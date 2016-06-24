//
//  NSString+ZJTLib.h
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (ZJTLib)

-(NSDictionary*)zjt_jsonDict;

-(NSArray*)zjt_jsonArray;

-(CGRect)zjt_rectWithFont:(UIFont*)font width:(CGFloat)width;

-(CGRect)zjt_rectWithFont:(UIFont*)font height:(CGFloat)height;

- (NSString*)zjt_urlEncodedString;

@end
