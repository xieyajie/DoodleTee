//
//  XDDrawPicker.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XDDrawView.h"

typedef enum{
    XDDrawTypeColorCircleNoRange = 0,  //不连续的生成，不同颜色，大小不同的圆
    XDDrawTypeColorCircleRangeBlack = 1, //不连续的生成，黑色系，大小不同的圆
    XDDrawTypeColorCircleRangeBlue = 2,    //不连续的生成，蓝色系，大小不同的圆
    XDDrawTypeColorLineNoRange = 3,   //彩色的线
    XDDrawTypeSkyBlueLine = 4  //天蓝色的线
}XDDrawType;

@class XDDrawView;
@interface XDDrawPicker : NSObject

@property (nonatomic, retain) XDDrawView *effectView;//正在编辑的区域

@property (nonatomic, assign) BOOL useRandomColorNoRange;//画笔颜色没有范围，在0-255之间自动生成
@property (nonatomic, assign) BOOL useRandomColorRange;//画笔颜色有自动生成的范围

@property (nonatomic, retain) UIColor *brushColor;
@property (nonatomic, assign) CGFloat brushSize;
@property (nonatomic, assign) XDDrawType brushType;

@property (nonatomic, assign) CGFloat fromColorValue;
@property (nonatomic, assign) CGFloat toColorValue;

- (id)initWithEffectViewSize:(CGSize)size;

- (void)drawWithType:(XDDrawType)type;

- (void)clear;

@end
