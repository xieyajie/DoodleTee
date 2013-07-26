//
//  XDXDDrawView.m
//  DoodleTee
//
//  Created by xieyajie on 13-6-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDDrawView.h"

#import "XDDrawPicker.h"

#import "UIColor_Random.h"

@interface XDDrawView()
{
    UIImage *_image;//绘图结果保存成的图片
    UIColor *_drawColor;
    
    CGPoint _beginTouch;
    CGPoint _lastTouch;
    
    BOOL _needSave;
    
    CGPoint _lastDrowCyclePoint;
    CGFloat _lastDrowCycleRadius;
    
    BOOL _needClear;
}

@property (nonatomic, strong) UIColor *drawColor;

@end

@implementation XDDrawView

@synthesize picker = _picker;

@synthesize image = _image;

@synthesize drawColor = _drawColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeVariable];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeVariable];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (_needClear)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextFillRect(context, self.bounds);
        _needClear = NO;
        
        return ;
    }
    
    //加载上一次的绘图结果
    if (_image) {
        [_image drawInRect:[self bounds]];
    }
    
    //自由画曲线
    if (XDDrawTypeColorLineNoRange == self.picker.brushType ||
        XDDrawTypeSkyBlueLine == self.picker.brushType)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, self.drawColor.CGColor);
        CGContextSetFillColorWithColor(context, self.drawColor.CGColor);
        CGContextSetLineWidth(context, self.picker.brushSize);
        CGContextSetLineCap(context, kCGLineJoinRound); //线条开始样式，设置为平滑
        CGContextSetLineJoin(context, kCGLineJoinRound);//线条拐角样式，设置为平滑
        
        CGContextMoveToPoint(context, _beginTouch.x, _beginTouch.y);
        CGContextAddLineToPoint(context, _lastTouch.x, _lastTouch.y);
        CGContextStrokePath(context);
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        self.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
    //画圆圈
    else
    {
        self.drawColor = [self configurationColorWithBrushType:self.picker.brushType];
        [self randomACycleAtPoint: _lastTouch];
    }
}

#pragma mark - private

- (void)initializeVariable
{
    self.clipsToBounds = YES;
    _needClear = YES;
}

#pragma mark - touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _beginTouch = [touch locationInView:self];
    
    BOOL isInside = [self pointInside: _beginTouch withEvent: nil];
    if (!isInside)
    {
        return;
    }
    
    _beginTouch = [touch locationInView:self];
	_lastTouch = [touch locationInView:self];
    
    self.drawColor = [self configurationColorWithBrushType:self.picker.brushType];
    if (XDDrawTypeColorCircleRangeBlack == self.picker.brushType ||
        XDDrawTypeColorCircleRangeBlue == self.picker.brushType || XDDrawTypeColorCircleNoRange == self.picker.brushType)
    {
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
//    _needDisplay = NO;
    
    _beginTouch = [touch previousLocationInView:self];
    _lastTouch = [touch locationInView:self];
    
    BOOL isInside = [self pointInside: _lastTouch withEvent: nil];
    if (!isInside)
    {
        return;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _lastTouch = [touch locationInView:self];
    
    BOOL isInside = [self pointInside: _lastTouch withEvent: nil];
    if (!isInside)
    {
        return;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - private 画笔颜色

//设置画笔颜色
- (UIColor *)configurationColorWithBrushType:(XDDrawType)type
{
    if (self.picker.useRandomColorNoRange) {
        return [UIColor randomColor];
    }
    else if (self.picker.useRandomColorRange)
    {
       return [self randomColorWithBrushType:self.picker.brushType];
    }
    else{
        return self.picker.brushColor;
    }
}

//自由获取画笔色系颜色
- (UIColor *)randomColorWithBrushType:(XDDrawType)type
{
    switch (type) {
        case XDDrawTypeColorCircleRangeBlack:
        {
            return [UIColor randomBlackSeries];
        }
            break;
        case XDDrawTypeColorCircleRangeBlue:
        {
            return [UIColor randomBlueSeries];
        }
            break;
            
        default:
            return [UIColor clearColor];
            break;
    }
}

#pragma mark - private 画圆

- (void)randomACycleAtPoint:(CGPoint)point
{
    [self drawCycleWithPoint: point
                      radius: random()% 13
                       color: self.drawColor];
}

- (void)drawCycleWithPoint:(CGPoint)point radius:(CGFloat)radius color:(UIColor*)color
{
    CGRect rect = CGRectMake(point.x, point.y, 2*radius, 2*radius);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextFillEllipseInRect(context, rect);
    CGContextStrokePath(context);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    self.image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    _lastDrowCyclePoint = point;
    _lastDrowCycleRadius = radius;
}

- (CGFloat)distanceForPoint:(CGPoint)point andPoint:(CGPoint)anotherPoint
{
    CGFloat distance = sqrt((point.x*point.x - anotherPoint.x*anotherPoint.x) + (point.y*point.y - anotherPoint.y*anotherPoint.y));
    
    return distance;
}

#pragma mark - public

- (void)clear
{
    self.image = nil;
    _needClear = YES;
    
    [self setNeedsDisplay];
}

@end
