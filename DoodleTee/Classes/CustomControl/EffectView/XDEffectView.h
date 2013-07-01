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
    XDEffectTypeProcess = 0,
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
//    UIImage *_currentImage;         //当前编辑中的图片
    
    NSMutableArray *_imageArray;
    
    UIImage *_originalImage;        //原始图片
    
    XDDrawType _drawType;
    XDEffectType _effectType;
}

@property (nonatomic, assign) XDEffectType effectType;

@property (nonatomic, assign) UIColor *drawColor;
@property (nonatomic, assign) UIColor *bgColor;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, readonly) NSInteger undoSteps;

//@property (nonatomic, retain) UIImage *image;  //编辑图片

//- (void)setEffectType:(XDEffectType)aEffectType;

//- (void)setImage:(UIImage *)image;

//- (void)setCache:(UIView *)cacheView;

- (void)processImageToState:(XDProcessState)state;

- (void)drawForType:(XDDrawType)type;

- (void)undo;

//- (UIImage *)imageWithCurrentContext;


- (void)layoutEditorAreaWithObject:(id)object;

- (id)cacheWithCurrentContext;

@end