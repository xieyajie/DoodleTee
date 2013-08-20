//
//  XDShareMethods.m
//  DoodleTee
//
//  Created by xie yajie on 13-7-7.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDShareMethods.h"
#import "Reachability.h"

#import "LocalDefault.h"

static XDShareMethods *shareDefult = nil;

@implementation XDShareMethods

+ (id)defaultShare
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        shareDefult = [[XDShareMethods alloc] init];
    });
    return shareDefult;
}

//+ (BOOL)isConnectedToNetwork
//{
//	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:
//			return NO;
//        case ReachableViaWWAN:
//			return YES;
//        case ReachableViaWiFi:
//			return YES;
//    }
//    return NO;
//}

+ (CGFloat)currentVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag formViewController:(UIViewController *)fromViewController completion:(void (^)(void))completion
{
    if ([XDShareMethods currentVersion] >= 5.0) {
        [fromViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
    else{
        if (completion != nil) {
            completion();
        }
        
        [fromViewController presentModalViewController:viewControllerToPresent animated:flag];
    }
}

+ (void)dismissViewController:(UIViewController *)viewController animated:(BOOL)flag completion: (void (^)(void))completion
{
    if ([XDShareMethods currentVersion] >= 5.0)
    {
        [viewController dismissViewControllerAnimated:flag completion:completion];
    }
    else{
        if (completion != nil) {
            completion();
        }
        [viewController dismissModalViewControllerAnimated:flag];
    }
}

#pragma mark - 合并图片

- (CGRect)effectViewFrameWithSuperView:(UIView *)view
{
    return CGRectMake(view.frame.size.width * kEffectLeftMarginScale, view.frame.size.height * kEffectTopMarginScale, view.frame.size.width * kEffectWidthScale, view.frame.size.height * kEffectHeightScale);
}

- (UIImage *)composeImage:(UIImage *)subImage toImage:(UIImage *)superImage finishToView:(UIView *)view
{
//    int width = superImage.size.width;
//    int height = superImage.size.height;
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    //create a graphic context with CGBitmapContextCreate
//    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGContextDrawImage(context, CGRectMake(0, 0, width, height), superImage.CGImage);
//    CGContextDrawImage(context, [self effectViewFrameWithSuperView:view], [subImage CGImage]);
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return [UIImage imageWithCGImage:imageMasked];
    
    CGSize superSize = superImage.size;
    UIGraphicsBeginImageContext(superSize);
    [superImage drawInRect:CGRectMake(0, 0, superSize.width, superSize.height)];
    [subImage drawInRect:[self effectViewFrameWithSuperView:view]];
    __autoreleasing UIImage *finish = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finish;
}

@end
