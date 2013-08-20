//
//  LocalDefault.h
//  DoodleTee
//
//  Created by xieyajie on 13-6-27.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#ifndef DoodleTee_LocalDefault_h
#define DoodleTee_LocalDefault_h

//支付宝相关
#define kPartnerId @"2088011485123579"
#define kSellerId @"2088011485123579"
//end

#if !defined __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
# define KTextAlignmentLeft UITextAlignmentLeft
# define KTextAlignmentCenter UITextAlignmentCenter
# define KTextAlignmentRight UITextAlignmentRight

#else
# define KTextAlignmentLeft NSTextAlignmentLeft
# define KTextAlignmentCenter NSTextAlignmentCenter
# define KTextAlignmentRight NSTextAlignmentRight
#endif

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height - 20

#define kViewX 20
#define kViewWidth 280

#define kTitleY 13
#define kTitleHeight 30

#define kBottomHeight 62.5

//start 编辑区域边框
#define kEffectWidthScale 254/616
#define kEffectHeightScale 336/637

#define kEffectLeftMarginScale 184/616
#define kEffectRightMarginScale 178/616
#define kEffectTopMarginScale 170/637
#define kEffectBottomMarginScale 131/637
//end

//用户名
#define kUserDefaultsUserName @"userName"

//本地沙盒中图片路径
#define kLocalImagePath @"Documents/custom/"

//通知名称
#define kNotificationFinishName @"finishedEffect"
#define kNotificationLandSuccess @"landSuccess"


//其他
#define kUnitPrice 20.0

#define KSETTINGPLIST @"setting.plist"
#define kSETTINGBRAND @"品牌"
#define kSETTINGMATERIAL @"材质"
#define kSETTINGCOLOR @"颜色"
#define kSETTINGSIZE @"尺码"
#define kSETTINGCOUNT @"数量"
#define kSETTINGMONEY @"价格"

#define kACCOUNTCONSIGNEE @"常用收货信息"
#define kACCOUNTPAY @"常用支付信息"
#define kACCOUNTDESIGN @"设计历史"
#define kACCOUNTBUY @"购买历史"
#define kACCOUNTSELL @"销售历史"

#endif
