//
//  XDImagePicker.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    XDProcessStateNormal = 0,  //原始状态
    XDProcessStateBlackAndWhite = 1, //黑白
    XDProcessStateLomo = 2,    //lomo
    XDProcessStateBlues = 3,   //蓝调
    XDProcessStateGothic = 4,  //哥特
    XDProcessStateSharpen = 5, //锐化
    XDProcessStateVintage, //复古
    XDProcessStateHalo,    //光晕
    XDProcessStateDream,   //梦幻
    XDProcessStateDarlness,//夜色
    XDProcessStateRomantic,//浪漫
    XDProcessStateQuietly, //淡雅
    XDProcessStateClaret,  //酒红
}XDProcessState;


@interface XDImagePicker : NSObject

@property (nonatomic, retain) UIImage *originalImage;//原始图片

@property (nonatomic, retain) UIImageView *effectView;//正在编辑的图片

- (id)initWithEffectViewFrame:(CGRect)frame;

- (void)effectImageToState:(XDProcessState)state;

@end
