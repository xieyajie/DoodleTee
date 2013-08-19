//
//  XDDataCenter.h
//  New
//
//  Created by ed on 12-9-11.
//
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"

typedef void (^XDCompleteBlock)(id);
typedef MKNKErrorBlock XDErrorBlock;

@interface XDDataCenter : NSObject

+ (XDDataCenter*)sharedCenter;

- (NSUInteger)cacheSize;
- (void)cacheData;

- (void)registerWithUserName:(NSString *)aUserName password:(NSString *)aPassword realName:(NSString *)aRealName tel:(NSString *)aTel address:(NSString *)aAddress complete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError;

- (void)loginWithUserName:(NSString *)aUserName password:(NSString *)aPassword complete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError;

- (void)uploadImageWithPath:(NSString *)aPath userName:(NSString *)aUserName complete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError;

- (void)orderWithUserName:(NSString *)aUserName colcor:(NSString *)aColor material:(NSString *)aMaterial size:(NSString *)aSize brand:(NSString *)aBrand count:(NSInteger)aCount money:(CGFloat)aMoney complete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError;

@end
