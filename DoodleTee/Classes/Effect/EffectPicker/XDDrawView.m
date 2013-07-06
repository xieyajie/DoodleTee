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
}

@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) UIColor *drawColor;

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
    //加载上一次的绘图结果
    if (_image) {
        [_image drawInRect:[self bounds]];
//        _needSave = YES;
    }
    else{
//        _needSave = NO;
    }
    
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
}

#pragma mark - private

- (void)initializeVariable
{
    self.clipsToBounds = YES;
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
    
    //设置画笔颜色
    if (self.picker.useRandomColorNoRange) {
        self.drawColor = [UIColor randomColor];
    }
    else if (self.picker.useRandomColorRange)
    {
        self.drawColor = [UIColor randonColorWithRangeForm:self.picker.fromColorValue to:self.picker.toColorValue];
    }
    else{
        self.drawColor = self.picker.brushColor;
    }
    
    _beginTouch = [touch locationInView:self];
	_lastTouch = [touch locationInView:self];
//    _needDisplay = NO;
    
    if (XDDrawTypeColorCircleNoRange == self.picker.brushType ||
        XDDrawTypeColorCircleRangeBlack == self.picker.brushType ||
        XDDrawTypeColorCircleRangeBlue == self.picker.brushType)
    {
        [self randomACycleAtPoint: _beginTouch];
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
    
    if (XDDrawTypeColorCircleNoRange == self.picker.brushType ||
        XDDrawTypeColorCircleRangeBlack == self.picker.brushType ||
        XDDrawTypeColorCircleRangeBlue == self.picker.brushType)
    {
//        if ([self distanceForPoint: _lastTouch andPoint: _beginTouch] >= _lastDrowCycleRadius)
//        {
            [self randomACycleAtPoint: _lastTouch];
//        }
    }
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

#pragma mark - private
- (void)randomACycleAtPoint:(CGPoint)point
{
    UIColor *color = nil;
    if (XDDrawTypeColorCircleNoRange == self.picker.brushType)
    {
        color = [UIColor colorWithRed: random()%255/255.0f
                                green: random()%255/255.0f
                                 blue: random()%255/255.0f
                                alpha: random()%255/(255.0f/4.0f)];
    }
    else if (XDDrawTypeColorCircleRangeBlack == self.picker.brushType)
    {
        CGFloat value = random()%255/(255.0f*2.0f);
        color = [UIColor colorWithRed: value
                                green: value
                                 blue: value
                                alpha: random()%255/(255.0f/4.0f)];
    }
    else if (XDDrawTypeColorCircleRangeBlue == self.picker.brushType)
    {
        color = [UIColor colorWithRed: random()%255/(255.0f*2.0f)
                                green: random()%255/(255.0f*2.0f)
                                 blue: random()%255/(255.0f/2.0f)
                                alpha: random()%255/(255.0f/4.0f)];
    }
    [self drawCycleWithPoint: point
                      radius: random()%13
                       color: color];
}

- (void)drawCycleWithPoint:(CGPoint)point radius:(CGFloat)radius color:(UIColor*)color
{
    CGRect cycleRect = CGRectMake(0, 0, 2*radius, 2*radius);
    
    UIGraphicsBeginImageContextWithOptions(cycleRect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, cycleRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    imageView.center = point;
    [self addSubview: imageView];
    [imageView release];
    
    _lastDrowCyclePoint = point;
    _lastDrowCycleRadius = radius;
}

- (CGFloat)distanceForPoint:(CGPoint)point andPoint:(CGPoint)anotherPoint
{
    CGFloat distance = sqrt((point.x*point.x - anotherPoint.x*anotherPoint.x) + (point.y*point.y - anotherPoint.y*anotherPoint.y));
    
    return distance;
}

#pragma mark - public

@end
