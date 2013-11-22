//
//  XDAppDelegate.m
//  DoodleTee
//
//  Created by xie yajie on 13-5-28.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDAppDelegate.h"

#import <ShareSDK/ShareSDK.h>
#import <sys/utsname.h>
#import "AlixPay.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"

#import "XDRootViewController.h"
#import "LocalDefault.h"

#define SHARESDK_APPKEY @"53a75cfb340"

//#define SINAWEIBO_APPKEY @"1251171938"
//#define SINAWEIBO_APPSECRET @"c3902934f160d04152be60dd1db7131b"
//#define SINAWEIBO_REDIRECTURL @"http://www.sina.com"

#define SINAWEIBO_APPKEY @"1875815773"
#define SINAWEIBO_APPSECRET @"02190656983838ddbfa2b80d78c1ae75"
#define SINAWEIBO_REDIRECTURL @"http://demomonkeys.org/"

#define TENCENTWEIBO_APPKEY @"801379879"
#define TENCENTWEIBO_APPSECRET @"f4715cb1e72046e5e3fef967d1998cbf"
#define TENCENTWEIBO_REDIRECTURL @"http://www.qq.com"

#define TENCENTQZONE_APPKEY @"100477361"
#define TENCENTQZONE_APPSECRET @"72fbceff8eb8acdbc09f2e65ccf03b47"

#define RENREN_APPKEY @"2c26831c0e974fe0af9e26e68b872aca"
#define RENREN_APPSECRET @"fcb380838b0e474291378305c6860421"

@implementation XDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化SDK使用的appKey
    [ShareSDK registerApp:SHARESDK_APPKEY];
    //为各个分享平台的应用信息进行设置
    [self initializePlat];
    
    //
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    XDRootViewController *rootViewController = [[XDRootViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//在使用SSO授权方式（即跳转到相应客户端进行授权的方式）或者集成微信、QQ好友分享时，需要在处理请求URL的委托方法中加入ShareSDK的处理方法
//- (BOOL)application:(UIApplication *)application
//      handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url wxDelegate:self];
//}
//

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString  *)sourceApplication
         annotation:(id)annotation
{
    if ([sourceApplication isEqualToString:@"com.alipay.safepayclient"]) {
        [self parseURL:url application:application];
        return YES;
    }
    else{
        return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
    }
}

#pragma mark - ShareSDK

- (void)initializePlat
{
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:SINAWEIBO_APPKEY
                               appSecret:SINAWEIBO_APPSECRET
                             redirectUri:SINAWEIBO_REDIRECTURL];
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:TENCENTWEIBO_APPKEY
                                  appSecret:TENCENTWEIBO_APPSECRET
                                redirectUri:TENCENTWEIBO_REDIRECTURL];
    
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:TENCENTQZONE_APPKEY
                           appSecret:TENCENTQZONE_APPSECRET];
    
    //添加人人网应用
    [ShareSDK connectRenRenWithAppKey:RENREN_APPKEY
                            appSecret:RENREN_APPSECRET];
}

#pragma mark - 

- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
	AlixPay *alixpay = [AlixPay shared];
	AlixPayResult *result = [alixpay handleOpenURL:url];
    
    NSInteger code = -3;
    NSString *message = @"支付失败，请重新操作";
    NSLog(@"%@",result);
	if (result)
    {
		//是否支付成功
		if (9000 == result.statusCode) {
			/*
			 *用公钥验证签名
			 */
			id<DataVerifier> verifier = CreateRSADataVerifier([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"]);
			if ([verifier verifyString:result.resultString withSign:result.signString]) {
                code = 1;
                message = @"付款成功";
			}//验签错误
			else {
                code = 1;
                message = @"付款成功，但是签名错误";
			}
		}
		//如果支付失败,可以通过result.statusCode查询错误码
		else {
			code = -2;
            message = result.statusMessage;
		}
	}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPayRecall object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:code], kREQUESTRESULTCODE, message, kREQUESTRESULTINFO, nil]];
}


@end
