//
//  XDDrawPicker.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDDrawPicker.h"

@interface XDDrawPicker ()

@end

@implementation XDDrawPicker

@synthesize effectView = _effectView;

- (id)initWithEffectViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        _effectView = [[UIView alloc] initWithFrame:frame];
        _effectView.backgroundColor = [UIColor greenColor];
    }
    return self;
}


@end
