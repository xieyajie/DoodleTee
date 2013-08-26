//
//  XDShareMethods.h
//  DoodleTee
//
//  Created by xie yajie on 13-7-7.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDShareMethods : NSObject

+ (id)defaultShare;

//+ (BOOL)isConnectedToNetwork;

//当前版本
+ (CGFloat)currentVersion;

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag formViewController:(UIViewController *)fromViewController completion:(void (^)(void))completion;

+ (void)dismissViewController:(UIViewController *)viewController animated: (BOOL)flag completion: (void (^)(void))completion;


- (CGRect)effectViewFrameWithSuperView:(UIView *)view;

- (UIImage *)composeImage:(UIImage *)subImage toImage:(UIImage *)superImage finishToView:(UIView *)view;


//保存自绘制的图片到本地
+ (NSString *)saveCustomImage:(UIImage *)image imageName:(NSString *)imgName;

//保存微博头像到本地
+ (BOOL)saveSinaIconToLocal:(NSData *)imageData;
//获取微博头像
+ (UIImage *)getSinaIconFromLocal;

@end
