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
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.picker.brushSize);
	CGContextSetLineCap(context, kCGLineJoinRound); //线条开始样式，设置为平滑
	CGContextSetLineJoin(context, kCGLineJoinRound);//线条拐角样式，设置为平滑
//	patterns[1].pattern[0] = self.picker.brushSize + 10;
//	if (DashLinePatternIndex == 1) {
//		CGContextSetLineDash(context, 5.0f, patterns[DashLinePatternIndex].pattern,
//                             patterns[DashLinePatternIndex].count);
//	}
	CGContextSetStrokeColorWithColor(context, self.drawColor.CGColor);
	CGContextSetFillColorWithColor(context, self.drawColor.CGColor);
//	CGRect currentRect = CGRectMake(
//								    (_beginTouch.x > _lastTouch.x) ? _lastTouch.x : _beginTouch.x,
//								    (_beginTouch.y > _lastTouch.y) ? _lastTouch.y : _beginTouch.y,
//								    fabsf(_beginTouch.x - _lastTouch.x),
//								    fabsf(_beginTouch.y - _lastTouch.y));
    
//    if (_needSave) {
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        self.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
//    }
}

#pragma mark - private

- (void)initializeVariable
{
    
}

#pragma mark - touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _beginTouch = [touch locationInView:self];
    
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
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
//    _needDisplay = NO;
    
    _beginTouch = [touch previousLocationInView:self];
    _lastTouch = [touch locationInView:self];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _lastTouch = [touch locationInView:self];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - private


#pragma mark - public

@end
