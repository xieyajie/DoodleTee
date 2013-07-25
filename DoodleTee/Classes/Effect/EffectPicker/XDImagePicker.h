//
//  XDImagePicker.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GPUImage.h"

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

@property (nonatomic, retain, setter = setImage:) UIImage *image;//原始图片

@property (nonatomic, retain) GPUImageView *effectView;//正在编辑的图片

@property (nonatomic, assign) BOOL isStatic;

- (id)initWithEffectViewSize:(CGSize)size;

- (void)effectImageToType:(XDProcessType)type;

- (void)startCamera;

- (void)clear;

@end
