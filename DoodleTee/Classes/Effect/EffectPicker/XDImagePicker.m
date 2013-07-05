//
//  XDImagePicker.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDImagePicker.h"

#import "ImageUtil.h"

#import "ColorMatrix.h"

@interface XDImagePicker ()

@end

@implementation XDImagePicker

@synthesize originalImage = _originalImage;
@synthesize effectView = _effectView;

- (id)initWithEffectViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        _effectView = [[UIImageView alloc] initWithFrame:frame];
        _effectView.backgroundColor = [UIColor redColor];
    }
    return self;
}

#pragma mark - public

- (void)effectImageToState:(XDProcessState)state
{
    if (_originalImage == nil) {
        return ;
    }
    
    switch (state) {
        case XDProcessStateNormal:
        {
            _effectView.image = _originalImage;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case XDProcessStateLomo:
        {
            _effectView.image = [ImageUtil imageWithImage:_originalImage withColorMatrix: colormatrix_lomo];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case XDProcessStateBlackAndWhite:
        {
            _effectView.image = [ImageUtil imageWithImage:_originalImage withColorMatrix:colormatrix_heibai];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case XDProcessStateBlues:
        {
            _effectView.image = [ImageUtil imageWithImage:_originalImage withColorMatrix:colormatrix_landiao];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case XDProcessStateGothic:
        {
            _effectView.image = [ImageUtil imageWithImage:_originalImage withColorMatrix:colormatrix_gete];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
            
        default:
            break;
    }
}

@end
