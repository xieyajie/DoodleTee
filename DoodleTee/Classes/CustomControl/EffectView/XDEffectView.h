//
//  XDEffectView.h
//  DoodleTee
//
//  Created by xieyajie on 13-6-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#import "ProcessState.h"

typedef enum{
    XDEffectTypeProcess,
    XDEffectTypeDraw,
    XDEffectTypeText
}XDEffectType;

typedef enum{
    XDDrawTypePoint,
    XDDrawTypePen
}XDDrawType;

@protocol XDDrawTools;
@interface XDEffectView : UIView<UITextViewDelegate>
{
    UIImageView *_imageView;
    
    UIImage *_originalImage;        //原始图片
    UIImage *_currentImage;         //当前编辑中的图片
    
    XDDrawType _drawType;
}

@property (nonatomic, retain, readonly) UIImage *currentImage;
@property (nonatomic, assign) XDEffectType effectType;

@property (nonatomic, assign) UIColor *drawColor;
@property (nonatomic, assign) UIColor *bgColor;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, readonly) NSInteger undoSteps;

- (void)setImage:(UIImage *)image;

- (void)processImageToState:(XDProcessState)state;

- (void)drawForType:(XDDrawType)type;

@end
