//
//  XDTextPicker.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    XDTextTypeClearBgBlackFont = 0,  //透明背景色，黑色字体
    XDTextTypeClearBgSkyBlueFont = 1, //透明背景色，天蓝色字体
    XDTextTypeClearBgRedFont = 2,    //透明背景色，红色字体
    XDTextTypeBlackBgWhiteFont = 3,   //黑背景色，白色字体
    XDTextTypeSkyBlueBgWhiteFont = 4  //天蓝背景色，白色字体
}XDTextType;

@interface XDTextPicker : NSObject

@property (nonatomic, strong) UITextView *effectView;//正在编辑的文字输入区域

- (id)initWithEffectViewSize:(CGSize)size;

- (void)textWithType:(XDTextType)state;

- (UIImage *)imageWithContext;

- (void)clear;

@end
