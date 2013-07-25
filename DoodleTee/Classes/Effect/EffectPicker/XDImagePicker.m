//
//  XDImagePicker.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <AssetsLibrary/AssetsLibrary.h>

#import "XDImagePicker.h"

#import "GPUImage.h"

#import "ImageUtil.h"

#import "ColorMatrix.h"

@interface XDImagePicker ()
{
    GPUImageView *_cameraView;
    GPUImageStillCamera *_stillCamera;
    GPUImageFilter *_filter;
}

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
        _effectView.backgroundColor = [UIColor clearColor];
        
        _cameraView = [[GPUImageView alloc] initWithFrame:frame];
        _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
        _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }
    return self;
}

#pragma mark - public

- (void)effectImageToType:(XDProcessType)type
{
    if (_originalImage == nil) {
        return ;
    }
    
    switch (type) {
        case XDProcessTypeNormal:
        {
            _effectView.image = _originalImage;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case XDProcessTypeLomo:
        {
            _effectView.image = [ImageUtil imageWithImage:_originalImage withColorMatrix: colormatrix_lomo];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case XDProcessTypeBlackAndWhite:
        {
            _effectView.image = [ImageUtil imageWithImage:_originalImage withColorMatrix:colormatrix_heibai];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case XDProcessTypeBlues:
        {
            _effectView.image = [ImageUtil imageWithImage:_originalImage withColorMatrix:colormatrix_landiao];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case XDProcessTypeGothic:
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

- (void)effectCameraToType:(XDProcessType)type
{
    [_effectView addSubview:_cameraView];
    [_stillCamera removeTarget:_filter];
    switch (type)
    {
        case 0:
            _filter = nil;
            break;
        case 1:
            _filter = [[GPUImageSketchFilter alloc] init];
            break;
        case 2:
            _filter = [[GPUImageSoftLightBlendFilter alloc] init];
            break;
        case 3:
            _filter = [[GPUImageColorBurnBlendFilter alloc] init];
            break;
        case 4:
            _filter = [[GPUImagePolkaDotFilter alloc] init];
            break;
            
            default:
            break;
    }
    
    if (type != 0) {
        [_stillCamera addTarget:_filter];
        [_filter addTarget:_cameraView];
    }
    
    [_stillCamera startCameraCapture];
}

- (void)clear
{
    self.originalImage = nil;
    self.effectView.image = nil;
}

@end
