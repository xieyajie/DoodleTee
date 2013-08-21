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

@end
