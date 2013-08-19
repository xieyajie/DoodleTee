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

- (CGRect)effectViewFrameWithSuperView:(UIView *)view
{
    return CGRectMake(view.frame.size.width * kEffectLeftMarginScale, view.frame.size.height * kEffectTopMarginScale, view.frame.size.width * kEffectWidthScale, view.frame.size.height * kEffectHeightScale);
}

- (UIImage *)composeImage:(UIImage *)subImage toImage:(UIImage *)superImage finishToView:(UIView *)view
{
    int width = superImage.size.width;
    int height = superImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), superImage.CGImage);
    CGContextDrawImage(context, [self effectViewFrameWithSuperView:view], [subImage CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}

@end
