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

#import "ImageUtil.h"
#import "LocalDefault.h"
#import "ColorMatrix.h"
#import "MBProgressHUD.h"

#define kTagEffectViewClose 0
#define kTagEffectViewOpen 1

@interface XDImagePicker ()
{
    GPUImageStillCamera *_stillCamera;
    GPUImageCropFilter *_cropFilter;
    
    GPUImageFilter *_filter;
    GPUImagePicture *_staticPicture;
    
    UIActivityIndicatorView *_activityView;
}

@end

@implementation XDImagePicker

@synthesize image = _image;
@synthesize effectView = _effectView;
@synthesize isStatic = _isStatic;

- (id)initWithEffectViewSize:(CGSize)size
{
    self = [super init];
    if (self) {
        // Custom initialization
        _effectView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//        _effectView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        
        _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
        _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        
        _cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
    }
    return self;
}

- (void)setImage:(UIImage *)aImage
{
    _image = aImage;
    
    _staticPicture = [[GPUImagePicture alloc] initWithImage:_image smoothlyScaleOutput:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetButton object:[NSNumber numberWithBool:NO]];
}

- (UIImage *)image
{
    return _image;
}

- (void)setFilter:(XDProcessType)type
{
    switch (type)
    {
        case 0:
            _filter = [[GPUImageRGBFilter alloc] init];;
            break;
        case 1:
            _filter = [[GPUImageSketchFilter alloc] init];
            break;
        case 2:
            _filter = [[GPUImageSepiaFilter alloc] init];
            break;
        case 3:
            _filter = [[GPUImageRGBFilter alloc] init];
            [(GPUImageRGBFilter *)_filter setGreen:2.0];
            break;
        case 4:
            _filter = [[GPUImageExposureFilter alloc] init];
            [(GPUImageExposureFilter *)_filter setExposure:1.1];
            break;
            
        default:
            break;
    }
}

- (void)removeAllTargets
{
    [_staticPicture removeAllTargets];
    [_stillCamera removeAllTargets];
    [_cropFilter removeAllTargets];
    [_filter removeAllTargets];
}

#pragma mark - public

- (void)effectImageToType:(XDProcessType)type
{
    if ((_isStatic && _staticPicture == nil) || (!_isStatic && _effectView.tag == kTagEffectViewClose)) {
        return ;
    }
    
    [self removeAllTargets];
    [self setFilter:type];
    
    if (self.isStatic) {
        _effectView.tag = kTagEffectViewOpen;
        [_staticPicture addTarget:_filter];
        [_filter addTarget:_effectView];
        [_staticPicture processImage];
//        _image = [_filter imageFromCurrentlyProcessedOutput];
    }
    else{
        _staticPicture = nil;
        
        [_stillCamera addTarget:_cropFilter];
        [_cropFilter addTarget:_filter];
        [_filter addTarget:_effectView];
        [_filter prepareForImageCapture];
    }
}

- (void)cameraTakePhotoWithFinishHandler:(void (^)(BOOL finish))completion
{
    [MBProgressHUD showHUDAddedTo:self.effectView animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetButton object:[NSNumber numberWithBool:NO]];
    [_stillCamera capturePhotoAsImageProcessedUpToFilter:_cropFilter
                                   withCompletionHandler:^(UIImage *image, NSError *error){
                                       runOnMainQueueWithoutDeadlocking(^{
                                           [_stillCamera stopCameraCapture];
                                           _staticPicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
                                           _image = [_filter imageFromCurrentlyProcessedOutputWithOrientation:UIImageOrientationUp];
                                           [self removeAllTargets];
                                           [MBProgressHUD hideAllHUDsForView:self.effectView animated:YES];
                                           completion(YES);
                                       });
                                   }];
}                

- (void)startCamera
{
    [_stillCamera startCameraCapture];
    _effectView.tag = kTagEffectViewOpen;
}

- (void)stopCamera
{
    [_stillCamera stopCameraCapture];
    [self removeAllTargets];
}

- (void)clear
{
    if (_isStatic) {
        [self stopCamera];
    }
    UIView *superView = _effectView.superview;
    CGSize size = _effectView.frame.size;
    
    [self removeAllTargets];
    [_effectView removeFromSuperview];
    self.isStatic = YES;
    _staticPicture = nil;
    _image = nil;

    _effectView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _effectView.tag = kTagEffectViewClose;
    _effectView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [superView addSubview:_effectView];
}

@end
