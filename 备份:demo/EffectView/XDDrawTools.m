//
//  XDDrawTools.m
//  DoodleTee
//
//  Created by xieyajie on 13-6-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDDrawTools.h"

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

#pragma mark - XDDrawPenTool

@implementation XDDrawPenTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;

@synthesize isColors = _isColors;

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.lineCapStyle = kCGLineCapRound;
        self.lineAlpha = 1.0;
    }
    return self;
}

- (void)setInitialPoint:(CGPoint)firstPoint
{
    [self moveToPoint:firstPoint];
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    [self addQuadCurveToPoint:midPoint(endPoint, startPoint) controlPoint:startPoint];
}

- (void)draw
{
    [self.lineColor setStroke];
    [self strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
}

@end


#pragma mark - XDDrawPointTool

@implementation XDDrawPointTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.lineCapStyle = kCGLineCapRound;
    }
    return self;
}

- (void)setInitialPoint:(CGPoint)firstPoint
{
    [self moveToPoint:firstPoint];
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    [self addQuadCurveToPoint:midPoint(endPoint, startPoint) controlPoint:startPoint];
}

- (void)draw
{
    [self.lineColor setStroke];
    [self strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
}


@end