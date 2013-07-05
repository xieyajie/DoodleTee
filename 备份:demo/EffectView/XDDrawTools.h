//
//  XDDrawTools.h
//  DoodleTee
//
//  Created by xieyajie on 13-6-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XDDrawTools <NSObject>

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

- (void)draw;

@end

@interface XDDrawPenTool : UIBezierPath<XDDrawTools>

@property (nonatomic, assign) BOOL isColors;

@end

@interface XDDrawPointTool : UIBezierPath<XDDrawTools>

@end