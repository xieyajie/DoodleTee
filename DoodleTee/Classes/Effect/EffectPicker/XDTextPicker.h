//
//  XDTextPicker.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    XDTextStateClearBgBlackFont = 0,  //透明背景色，黑色字体
    XDTextStateClearBgSkyBlueFont = 1, //透明背景色，天蓝色字体
    XDTextStateClearBgRedFont = 2,    //透明背景色，红色字体
    XDTextStateBlackBgWhiteFont = 3,   //黑背景色，白色字体
    XDTextStateSkyBlueBgWhiteFont = 4  //天蓝背景色，白色字体
}XDTextState;

@interface XDTextPicker : NSObject

@property (nonatomic, retain) UITextView *effectView;//正在编辑的文字输入区域

- (id)initWithEffectViewFrame:(CGRect)frame;

- (void)textWithState:(XDTextState)state;

- (void)textWithBackgroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor;

@end
