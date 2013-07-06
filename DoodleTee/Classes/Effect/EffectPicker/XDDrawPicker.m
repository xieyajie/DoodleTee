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
            _brushSize = 2.0;
            break;
        case XDDrawTypeSkyBlueLine:
            _useRandomColorNoRange = NO;
            _useRandomColorRange = NO;
            _brushColor = [UIColor blueColor];
            _brushSize = 2.0;
            break;
            
        default:
            break;
    }
}


@end
