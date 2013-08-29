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

//获取底衫图片名称
+ (NSString *)clotheImageName
{
    NSString *key = nil;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
    //未登录
    if (userName == nil || userName.length == 0) {
        key = kUserDefault;
    }
    else{
        key = userName;
    }
    
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent: KSETTINGPLIST];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath: plistPath])
    {
        return @"clothe_default.png";
    }
    
    NSMutableDictionary *setDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (setDic == nil) {
        return @"clothe_default.png";
    }
    
    NSMutableDictionary *settings = [setDic objectForKey:key];
    if (settings == nil)
    {
        return @"clothe_default.png";
    }
    
    NSString *imageName = [settings objectForKey:kSettingImageClothe];
    if (imageName == nil || imageName.length == 0) {
        return @"clothe_default.png";
    }
    
    return imageName;
}

//获取底衫图片
+ (UIImage *)clotheImage
{
    NSString *key = nil;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
    //未登录
    if (userName == nil || userName.length == 0) {
        key = kUserDefault;
    }
    else{
        key = userName;
    }
    
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent: KSETTINGPLIST];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath: plistPath])
    {
        return [UIImage imageNamed:@"clothe_default.png"];
    }
    
    NSMutableDictionary *setDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (setDic == nil) {
        return [UIImage imageNamed:@"clothe_default.png"];
    }
    
    NSMutableDictionary *settings = [setDic objectForKey:key];
    if (settings == nil)
    {
        return [UIImage imageNamed:@"clothe_default.png"];
    }
    
    NSString *imageName = [settings objectForKey:kSettingImageClothe];
    if (imageName == nil || imageName.length == 0) {
        return [UIImage imageNamed:@"clothe_default.png"];
    }
    
    return [UIImage imageNamed:imageName];
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

#pragma mark - 图片相关

//保存自绘制的图片到本地
+ (NSString *)saveCustomImage:(UIImage *)image imageName:(NSString *)imgName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
    //将图片存到本地沙盒内
    NSString *tmpPath = [NSString stringWithFormat:@"%@%@%@", kLocalDocuments, userName, kLocalCustomPath];
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent: tmpPath];
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@", savePath, imgName];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath: savePath])
    {
        [fileManage createDirectoryAtPath: savePath withIntermediateDirectories: YES attributes:nil error:nil];
    }
    
    NSData *imgData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    BOOL result = [imgData writeToFile:imgPath atomically:YES];
    
    if (result) {
        return imgPath;
    }
    else{
        return nil;
    }
}


//保存微博头像到本地
+ (BOOL)saveSinaIconToLocal:(NSData *)imageData
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
    //将图片存到本地沙盒内
    NSString *tmpPath = [NSString stringWithFormat:@"%@%@", kLocalDocuments, userName];
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent: tmpPath];
    
    NSString *imageName = [NSString stringWithFormat:@"%@_sinaIcon.png", userName];
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@", savePath, imageName];
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath: savePath])
    {
        [fileManage createDirectoryAtPath: savePath withIntermediateDirectories: YES attributes:nil error:nil];
    }
    
    return [imageData writeToFile:imgPath atomically:YES];
}

//获取微博头像
+ (UIImage *)getSinaIconFromLocal
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
    //将图片存到本地沙盒内
    NSString *tmpPath = [NSString stringWithFormat:@"%@%@", kLocalDocuments, userName];
    NSString *getPath = [NSHomeDirectory() stringByAppendingPathComponent: tmpPath];
    
    NSString *imageName = [NSString stringWithFormat:@"%@/%@_sinaIcon.png", getPath, userName];
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath: getPath])
    {
        NSData *iconData = [NSData dataWithContentsOfFile:imageName];
        return [UIImage imageWithData:iconData];
    }

    return nil;
}

#pragma mark - other

- (NSDictionary *)localEnToChDictionary
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"EnglishAndChinese" ofType:@"plist"];
   return [NSDictionary dictionaryWithContentsOfFile:filePath];

}

//根据英文获取对应中文
- (NSString *)chineseForString:(NSString *)eStr
{
    NSDictionary *dic = [self localEnToChDictionary];
    NSString *str = [dic objectForKey:eStr];
    if (str == nil) {
        str = eStr;
    }
    return str;
}

@end
