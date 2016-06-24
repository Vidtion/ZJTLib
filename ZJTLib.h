//
//  ZJTLib.h
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJTLibCategories.h"
#import "ZJTConfig.h"
#import "ZJTEntity.h"
#import "ZJTGlobal.h"
#import "ZJTPageControl.h"
#import "ZJTBlockAlertView.h"
#import "ZJTBlockActionSheet.h"
#import "ZJTDatabaseManager.h"
#import "ZJTPropertyHelper.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "UICollectionViewRightAlignedLayout.h"
#import "SCFrameAdaptiver.h"

@interface ZJTLib : NSObject

+(instancetype)sharedIncetance;

@property (nonatomic,strong) UIAlertView *showingAlert;

/**
 *  根据params和baseURL生成get请求的URL
 *
 *  @param baseURL 网址
 *  @param params  get请求参数字典
 *
 *  @return get请求最终的URL
 
 baseURL eg. http://www.baidu.com
 params eg. {jack:name}
 return eg. http://www.baidu.com?name=jack
 
 */
+(NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params;

+(NSString *)getStringFromUrl:(NSString*)url key:(NSString *)key;

+(NSString *)getStringFromUrl:(NSString*)url needle:(NSString *)needle;

/**
 *  十六进制颜色值
 */
+(UIColor *)hexStringToColor:(NSString *)stringToConvert;

#pragma mark - 弹窗
//弹窗
+ (void)alertWithMessage:(NSString *)message title:(NSString*)title buttonName:(NSString *)buttonname;
+ (void)alertWithMessage:(NSString *)message title:(NSString*)title;
+ (void)alertWithMessage:(NSString *)message;

#pragma mark - GCD
+(void)dispatchGetMainQueue:(dispatch_block_t)block;
+(void)dispatchGetGlobalQueue:(dispatch_block_t)block;

//广播通知
+(void)postNotif:(NSString*)name
            dict:(id)dict;

+(void)postNotif:(NSString*)name
          object:(id)object;

+(void)removeObserver:(id)observer
                 name:(NSString*)name;

//广播通知
+(void)postNotif:(NSString*)name;

//注册通知
+(void)addObserver:(id)observer
          selector:(SEL)selector
              name:(NSString*)name;

+(BOOL)isMobile:(NSString *)mobile;

+(BOOL)isEmailAddress:(NSString*)email;

+(CGFloat)getTextViewContentH:(UITextView *)textView;


//去除多余分割线
+(void)setExtraCellLineHidden:(UITableView *)tableView;

+(void)setTableViewInsetZero:(UITableView *)tableView;

/**
 *  @author PatrickCoin, 15-11-04 09:11:40
 *
 *  app build number
 */
+(NSString*)buildVersion;

/**
 *  @author PatrickCoin, 15-11-04 09:11:53
 *
 *  app version number
 */
+(NSString *)appVersion;

















@end
