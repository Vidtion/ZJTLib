//
//  ZJTLib.m
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import "ZJTLib.h"

@interface ZJTLib()<UIAlertViewDelegate>

@end

@implementation ZJTLib

+(instancetype)sharedIncetance
{
    static ZJTLib *incetance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      incetance = [[ZJTLib alloc] init];
                  });
    
    return incetance;
}

+ (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params
{
    if (params) {
        NSMutableArray* pairs = [NSMutableArray array];
        for (NSString* key in params.keyEnumerator) {
            NSString* value = [params objectForKey:key];
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        
        NSString* query = [pairs componentsJoinedByString:@"&"];
        NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [NSURL URLWithString:url];
    } else {
        return [NSURL URLWithString:baseURL];
    }
}

+(NSString *)getStringFromUrl:(NSString*)url key:(NSString *)key
{
    NSString *value = [ZJTLib getStringFromUrl:url needle:[NSString stringWithFormat:@"%@=",key]];
    return value;
}

+(NSString *)getStringFromUrl:(NSString*)url needle:(NSString *)needle
{
    NSString * str = nil;
    NSRange start = [url rangeOfString:needle];
    if (start.location != NSNotFound) {
        NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
        NSUInteger offset = start.location+start.length;
        str = end.location == NSNotFound
        ? [url substringFromIndex:offset]
        : [url substringWithRange:NSMakeRange(offset, end.location)];
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return str;
}

+(UIColor *)hexStringToColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (void)alertWithMessage:(NSString *)message title:(NSString*)title buttonName:(NSString *)buttonname
{
    UIAlertView *alert = [ZJTLib sharedIncetance].showingAlert;
    
    if ([alert.message isEqualToString:message]) {
        return ;
    }
    [ZJTLib dispatchGetMainQueue:^
     {
         UIAlertView *a = [[UIAlertView alloc] initWithTitle:title message:message delegate:[ZJTLib sharedIncetance] cancelButtonTitle:nil otherButtonTitles:buttonname, nil];
         [a show];
         
         [ZJTLib sharedIncetance].showingAlert = a;
     }];
}

+ (void)alertWithMessage:(NSString *)message title:(NSString*)title
{
    UIAlertView *alert = [ZJTLib sharedIncetance].showingAlert;
    
    if ([alert.message isEqualToString:message]) {
        return ;
    }
    
    [ZJTLib dispatchGetMainQueue:^
     {
         UIAlertView *a = [[UIAlertView alloc] initWithTitle:title message:message delegate:[ZJTLib sharedIncetance] cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [a show];
         [ZJTLib sharedIncetance].showingAlert = a;
     }];
}

+ (void)alertWithMessage:(NSString *)message
{
    [ZJTLib alertWithMessage:message title:@"提示"];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.showingAlert = nil;
}

+(void)dispatchGetMainQueue:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(),block);
}

+(void)dispatchGetGlobalQueue:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),block);
}

+(void)postNotif:(NSString*)name
            dict:(id)dict
{
    [ZJTLib dispatchGetMainQueue:^
     {
         NSLog(@"\n\n 主动通知 notification name = %@, user info = %@\n\n",name,dict);
         [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:dict];
     }];
}

+(void)postNotif:(NSString*)name
          object:(id)object
{
    NSDictionary *dict = nil;
    if (object)
    {
        dict = @{kDataKey:object};
    }
    [ZJTLib postNotif:name dict:dict];
}

+(void)postNotif:(NSString*)name
{
    [ZJTLib postNotif:name
               object:nil];
}

+(void)addObserver:(id)observer
          selector:(SEL)selector
              name:(NSString*)name
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:observer
               selector:selector
                   name:name
                 object:nil];
}

+(void)removeObserver:(id)observer
                 name:(NSString*)name
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:observer name:name object:nil];
}

+(BOOL)isMobile:(NSString *)mobile
{
    /**
     
     * 手机号码
     
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     * 联通：130,131,132,152,155,156,185,186
     
     * 电信：133,1349,153,180,189
     
     */
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     
     10         * 中国移动：China Mobile
     
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     12         */
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     
     15         * 中国联通：China Unicom
     
     16         * 130,131,132,152,155,156,185,186
     
     17         */
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     
     20         * 中国电信：China Telecom
     
     21         * 133,1349,153,180,189
     
     22         */
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    /**
     
     25         * 大陆地区固话及小灵通
     
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     
     27         * 号码：七位或八位
     
     28         */
    
    // NSString * PHS = @"^0(10|2[0-5789]|\d{3})\d{7,8}$";
    
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    
    
    if (([regextestmobile evaluateWithObject:mobile] == YES)
        
        || ([regextestcm evaluateWithObject:mobile] == YES)
        
        || ([regextestct evaluateWithObject:mobile] == YES)
        
        || ([regextestcu evaluateWithObject:mobile] == YES))
        
    {
        
        return YES;
        
    }
    
    else
        
    {
        
        return NO;
        
    }
    
}

+ (BOOL)isEmailAddress:(NSString*)email
{
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    }
    else
    {
        return textView.contentSize.height;
    }
}


//去除多余分割线
+(void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

+(void)setTableViewInsetZero:(UITableView *)tableView
{
    tableView.separatorColor = AppOtherColor5;
    tableView.separatorInset = UIEdgeInsetsZero;
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

+(NSString*)buildVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return app_build;
}

+(NSString *)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return app_Version;
}







@end
