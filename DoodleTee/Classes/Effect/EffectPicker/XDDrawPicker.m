//
//  XDDrawPicker.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDDrawPicker.h"

#import "XDDrawView.h"

@interface XDDrawPicker ()
{
    CGPoint _lastDrowCyclePoint;
    CGFloat _lastDrowCycleRadius;
}

@end

@implementation XDDrawPicker

@synthesize effectView = _effectView;

@synthesize useRandomColorNoRange = _useRandomColorNoRange;
@synthesize useRandomColorRange = _useRandomColorRange;

@synthesize brushColor = _brushColor;
@synthesize brushSize = _brushSize;
@synthesize brushType = _brushType;

@synthesize fromColorValue = _fromColorValue;
@synthesize toColorValue = _toColorValue;

- (id)initWithEffectViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        _effectView = [[XDDrawView alloc] initWithFrame:frame];
        _effectView.backgroundColor = [UIColor greenColor];
        _effectView.picker = self;
    }
    return self;
}

- (void)randomACycleAtPoint:(CGPoint)point
{
    [self drawCycleWithPoint: point
                      radius: random()%10
                       color: [UIColor colorWithRed: random()%255/255.0f
                                              green: random()%255/255.0f
                                               blue: random()%255/255.0f
                                              alpha: random()%255/255.0f]];
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
    [self.effectView addSubview: imageView];
    [imageView release];
    
    _lastDrowCyclePoint = point;
    _lastDrowCycleRadius = radius;
}

- (CGFloat)distanceForPoint:(CGPoint)point andPoint:(CGPoint)anotherPoint
{
    CGFloat distance = sqrt((point.x*point.x - anotherPoint.x*anotherPoint.x) + (point.y*point.y - anotherPoint.y*anotherPoint.y));
    
    return distance;
}

#pragma mark - Override Touch Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: self.effectView];
    
    [self randomACycleAtPoint: point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: self.effectView];
    
    if ([self distanceForPoint: _lastDrowCyclePoint andPoint: point] >= 2*_lastDrowCycleRadius)
    {
        [self randomACycleAtPoint: point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: self.effectView];
    
    [self randomACycleAtPoint: point];
}
#pragma mark - public

- (void)drawWithType:(XDDrawType)type
{
    switch (type) {
        case XDDrawTypeColorCircleNoRange:
            _useRandomColorNoRange = YES;
            _useRandomColorRange = NO;
            break;
        case XDDrawTypeColorCircleRangeBlack:
            _useRandomColorNoRange = NO;
            _useRandomColorRange = YES;
            _fromColorValue = 100;
            _toColorValue = 200;
            break;
        case XDDrawTypeColorCircleRangeBlue:
            _useRandomColorNoRange = NO;
            _useRandomColorRange = YES;
            _fromColorValue = 150;
            _toColorValue = 255;
            break;
        case XDDrawTypeColorLineNoRange:
            _useRandomColorNoRange = YES;
            _useRandomColorRange = NO;
            _brushSize = 20.0;
            break;
        case XDDrawTypeSkyBlueLine:
            _useRandomColorNoRange = NO;
            _useRandomColorRange = NO;
            _brushColor = [UIColor blueColor];
            _brushSize = 20.0;
            break;
            
        default:
            break;
    }
}


@end
