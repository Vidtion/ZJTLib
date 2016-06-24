//
//  NSString+ZJTLib.m
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import "NSString+ZJTLib.h"

@implementation NSString (ZJTLib)

-(NSDictionary*)zjt_jsonDict
{
    NSError *error;
    NSData *jData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jData options:kNilOptions error:&error];
    return jsonDict;
}

-(NSArray*)zjt_jsonArray
{
    NSError *error;
    NSData *jData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jData options:kNilOptions error:&error];
    return jsonArr;
}

-(CGRect)zjt_rectWithFont:(UIFont*)font width:(CGFloat)width
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin// | NSStringDrawingUsesFontLeading
                                           attributes:attributes
                                              context:nil];
    return rect;
}

-(CGRect)zjt_rectWithFont:(UIFont*)font height:(CGFloat)height
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin// | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    return rect;
}

- (NSString*)zjt_urlEncodedString
{
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    
    return encodedString;
}
@end
