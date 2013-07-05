//
//  XDDrawPicker.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDDrawPicker : NSObject

@property (nonatomic, retain) UIView *effectView;//正在编辑的区域

- (id)initWithEffectViewFrame:(CGRect)frame;

@end
