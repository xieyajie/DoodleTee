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
#define kEffectTempWidth 254.0
#define kEffectTempHeight 336.0

#define kEffectWidthScale 254.0/616.0
#define kEffectHeightScale 336.0/637.0

#define kEffectLeftMarginScale 184.0/616.0
#define kEffectRightMarginScale 178.0/616.0
#define kEffectTopMarginScale 170.0/637.0
#define kEffectBottomMarginScale 131.0/637.0
//end

//用户名
#define kUserDefault @"default"
#define kUserDefaultsUserName @"userName"

//本地沙盒中图片路径
#define kLocalDocuments @"Documents/"
#define kLocalCustomPath @"/CustomImage/"
#define kLocalInfoPath @"Documents/commonInfo.plist"

//通知名称
#define kNotificationSetButton @"setButton"
#define kNotificationFinishName @"finishedEffect"
#define kNotificationLandSuccess @"landSuccess"

//接口返回字段
#define kREQUESTRESULTCODE @"code"
#define kREQUESTRESULTINFO @"info"


//其他
#define kUnitPrice 20.0

#define KSETTINGPLIST @"Documents/setting.plist"
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

//订单 常用信息
#define kORDERCONSIGNEE @"consignee"
#define kORDERTEL @"tel"
#define kORDERADDRESS @"address"
#define kORDERPAYMENT @"payment"

#endif
