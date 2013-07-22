//
//  XDImagePicker.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    XDProcessTypeNormal = 0,  //原始状态
    XDProcessTypeBlackAndWhite = 1, //黑白
    XDProcessTypeLomo = 2,    //lomo
    XDProcessTypeBlues = 3,   //蓝调
    XDProcessTypeGothic = 4,  //哥特
    XDProcessTypeSharpen = 5, //锐化
    XDProcessTypeVintage, //复古
    XDProcessTypeHalo,    //光晕
    XDProcessTypeDream,   //梦幻
    XDProcessTypeDarlness,//夜色
    XDProcessTypeRomantic,//浪漫
    XDProcessTypeQuietly, //淡雅
    XDProcessTypeClaret,  //酒红
}XDProcessType;


@interface XDImagePicker : NSObject

@property (nonatomic, retain) UIImage *originalImage;//原始图片

@property (nonatomic, retain) UIImageView *effectView;//正在编辑的图片

- (id)initWithEffectViewFrame:(CGRect)frame;

- (void)effectImageToType:(XDProcessType)type;

- (void)effectCameraToType:(XDProcessType)type;

- (void)clear;

@end
