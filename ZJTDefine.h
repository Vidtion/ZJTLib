//
//  ZJTDefine.h
//  ZJTLib
//
//  Created by PatrickCoin on 9/16/15.
//  Copyright (c) 2015 ZJTSoft. All rights reserved.
//

#ifndef ZJTLib_ZJTDefine_h
#define ZJTLib_ZJTDefine_h

/**
 *  屏幕宽度
 */
#define ZJT_ViewWidth  CGRectGetWidth([UIScreen mainScreen].applicationFrame)

/**
 *  NSString、NSArray空值判断
 */
#define ZJT_isStringEmpty(S) (S == nil || S.length == 0)
#define ZJT_isStringValid(S) (S != nil && S.length != 0)
#define ZJT_isArrayEmpty(A) (A == nil || A.count == 0)
#define ZJT_isArrayValid(A) (A != nil && A.count != 0)

/**
 *  @author PatrickCoin, 2015-09-21 10:09:03
 *
 *  非空保护，如果值为nil，则用@"" @(0)代替
 */
#define ZJT_NotNilString(S) (S == nil ? @"":S)
#define ZJT_NotNilNumber(N) (N == nil ? @(0):N)

/**
 *  十六进制颜色
 */
#define ZJT_HexColor(X) [TCPublic hexStringToColor:X]

/**
 *  self的弱引用和强引用
 */
#define ZJT_WEAKSELF __block typeof(self) __weak weakSelf = self;
#define ZJT_STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;
#define ZJT_WEAKCELL __block typeof(cell) __weak weakCell = cell;

/**
 *  设备系统版本号
 */
#define ZJT_CurrentSystemVertion [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 *  沙盒路径定义
 */
#define ZJT_DocumentsPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define ZJT_LibraryPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]

/**
 *  Void Block
 */
typedef void (^ZJT_VoidBlock)(void);

static const NSString *kDataKey = @"kDataKey";











#endif
