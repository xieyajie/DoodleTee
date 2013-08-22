//
//  XDDataCenter.m
//  New
//
//  Created by ed on 12-9-11.
//
//
#import "XDDataCenter.h"
#import "JSONKit.h"

static NSString *kServerDataFileName = @"server_data.plist";

static NSString *kLocalAddress = @"http://127.0.0.1:8000";
static NSString *kServerAddress = @"www.doodletee.org";
static NSString *kAPIPath = @"doodletee/interface";

static NSString *kLoginAddress = @"LogonUser.php?";//get
static NSString *kRegisterAddress = @"RegisterUser.php?";//get
static NSString *kUploadImageAddress = @"UploadImage.php";//post
static NSString *kOrderAddress = @"UserOrder.php?";//get

#define kRequestRegisterKey @"Register"
#define kRequestLoginKey @"Login"

@interface XDDataCenter ()
{
    MKNetworkEngine *_netEngine;
    
    NSMutableDictionary *_infoCacheDic;
//    NSMutableDictionary *_requestDic;
}

- (void)requestInfo:(NSString*)aPath andOriginKey:(NSString*)aOriginKey andCacheKey:(NSString*)aCacheKey andRequestKey:(NSString*)aRequestKey onComplete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError;

@end

@implementation XDDataCenter

+ (XDDataCenter *)sharedCenter
{
    static dispatch_once_t once;
    static XDDataCenter *sharedCenter;
    dispatch_once(&once, ^ { sharedCenter = [[XDDataCenter alloc] init]; });
    return sharedCenter;
}

#pragma mark - Class life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        _netEngine = [[MKNetworkEngine alloc] initWithHostName: kServerAddress];
        _netEngine.apiPath = kAPIPath;
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSString *serverDataFilePath = [[_netEngine cacheDirectoryName] stringByAppendingPathComponent: kServerDataFileName];
        if ([fm fileExistsAtPath: serverDataFilePath])
        {
            _infoCacheDic = [[NSMutableDictionary alloc] initWithContentsOfFile: serverDataFilePath];
        }
        else
        {
            [fm createFileAtPath: serverDataFilePath contents: nil attributes: nil];
            _infoCacheDic = [[NSMutableDictionary alloc] init];
            
            [_infoCacheDic writeToFile: serverDataFilePath atomically: YES];
        }
        
//        _requestDic = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)cacheData
{
    NSString *serverDataFilePath = [[_netEngine cacheDirectoryName] stringByAppendingPathComponent: kServerDataFileName];
    [_infoCacheDic writeToFile: serverDataFilePath atomically: YES];
}

#pragma mark - Public methods

- (NSUInteger)cacheSize
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *readyDirectory = [_netEngine cacheDirectoryName];
    NSString *loadingDirectory = [readyDirectory stringByReplacingOccurrencesOfString: MKNETWORKCACHE_DEFAULT_DIRECTORY withString: @"loading"];
    unsigned long long readySize = [[fm attributesOfItemAtPath: readyDirectory error: nil] fileSize];
    unsigned long long loadingSize = [[fm attributesOfItemAtPath: loadingDirectory error: nil] fileSize];
    
    NSUInteger result = readySize + loadingSize - 136; // 此处假设两个文件夹中没有二级目录，则，两个文件夹所占大小为136；
    
    return result;
}

- (void)registerWithUserName:(NSString *)aUserName password:(NSString *)aPassword realName:(NSString *)aRealName tel:(NSString *)aTel address:(NSString *)aAddress complete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError
{
    NSString *realName = aRealName == nil ? @"" : aRealName;
    NSString *tel = aTel == nil ? @"" : aTel;
    NSString *address = aAddress == nil ? @"" : aAddress;
    
    NSString *path = [NSString stringWithFormat: @"%@UserName=%@&UserPWD=%@&Name=%@&Tel=%@&Address=%@", kRegisterAddress, aUserName, aPassword, realName, tel, address];
    [self requestInfo: path andOriginKey:nil andCacheKey:nil andRequestKey:kRequestRegisterKey onComplete: handleComplete onError: handleError];
}

- (void)loginWithUserName:(NSString *)aUserName password:(NSString *)aPassword complete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError
{
    NSString *path = [NSString stringWithFormat: @"%@UserName=%@&UserPWD=%@", kLoginAddress, aUserName, aPassword];
    [self requestInfo: path andOriginKey:nil andCacheKey:nil andRequestKey:kRequestLoginKey onComplete: handleComplete onError: handleError];
}

- (void)uploadImageWithPath:(NSString *)aPath userName:(NSString *)aUserName complete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError
{
    MKNetworkOperation *op = [_netEngine operationWithPath:kUploadImageAddress params:[NSDictionary dictionaryWithObjectsAndKeys: aUserName, @"UserName", nil] httpMethod:@"POST"];
    
    [op addFile:aPath forKey:@"img" mimeType:@"png"];
    
    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        NSData *data = [completedOperation responseData];
        CFStringRef stringRef = CFStringCreateWithBytes(NULL, [data bytes], [data length], kCFStringEncodingGB_18030_2000, false);
        NSString *string = [(__bridge NSString *)stringRef stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        CFRelease(stringRef);
        
        id result = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
        if (string != nil) {
            result = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:[string smallestEncoding]] options:NSJSONReadingMutableContainers error:nil];
            if (result == nil)
            {
                result = string;
            }
        }
#else
        NSData *data = [string dataUsingEncoding:[string smallestEncoding]];
        result = [data objectFromJSONData];
#endif
        
//        NSString *responseString = [completedOperation responseString];
//        NSLog(@"server response: %@",responseString);
        handleComplete(result);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error){
        NSLog(@"Upload file error: %@", error);
        handleError(error);
    }];
    
    [_netEngine enqueueOperation: op];
}

- (void)uploadImageWithData:(NSData *)aData imageName:(NSString *)aImageName userName:(NSString *)aUserName complete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError
{
    MKNetworkOperation *op = [_netEngine operationWithPath:kUploadImageAddress params:[NSDictionary dictionaryWithObjectsAndKeys: aUserName, @"UserName", nil] httpMethod:@"POST"];
    [op addHeader:@"Content-Type" withValue:@"multipart/form-data"];
    
    [op addData:aData forKey:@"image" mimeType:@"image/png" fileName:aImageName];
    
    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        NSData *data = [completedOperation responseData];
        CFStringRef stringRef = CFStringCreateWithBytes(NULL, [data bytes], [data length], kCFStringEncodingGB_18030_2000, false);
        NSString *string = [(__bridge NSString *)stringRef stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        CFRelease(stringRef);
        
        id result = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
        if (string != nil) {
            result = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:[string smallestEncoding]] options:NSJSONReadingMutableContainers error:nil];
            if (result == nil)
            {
                result = string;
            }
        }
#else
        NSData *data = [string dataUsingEncoding:[string smallestEncoding]];
        result = [data objectFromJSONData];
#endif
        
        //        NSString *responseString = [completedOperation responseString];
        //        NSLog(@"server response: %@",responseString);
        handleComplete(result);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error){
        NSLog(@"Upload file error: %@", error);
        handleError(error);
    }];
    
    [_netEngine enqueueOperation: op];
}

- (void)orderWithUserName:(NSString *)aUserName colcor:(NSString *)aColor material:(NSString *)aMaterial size:(NSString *)aSize brand:(NSString *)aBrand count:(NSInteger)aCount money:(CGFloat)aMoney complete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError
{
    NSString *path = [NSString stringWithFormat: @"%@UserName=%@&Color=%@&Material=%@&Size=%@&Brand=%@&Number=%i&Money=%.2f", kOrderAddress, aUserName, aColor, aMaterial, aSize, aBrand, aCount, aMoney];
    [self requestInfo: path andOriginKey:nil andCacheKey:nil andRequestKey:nil onComplete: handleComplete onError: handleError];
}


#pragma mark - Private methods

- (void)requestInfo:(NSString*)aPath andOriginKey:(NSString*)aOriginKey andCacheKey:(NSString*)aCacheKey andRequestKey:(NSString*)aRequestKey onComplete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError
{
    MKNetworkOperation *op= [_netEngine operationWithPath: aPath];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"Get post type Success");
        
        NSData *data = [operation responseData];
        CFStringRef stringRef = CFStringCreateWithBytes(NULL, [data bytes], [data length], kCFStringEncodingGB_18030_2000, false);
        NSString *string = [(__bridge NSString *)stringRef stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        CFRelease(stringRef);
        
        id result = nil;
        if (nil != aOriginKey)
        {
            NSDictionary *dic = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
            if (string != nil) {
                dic = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:[string smallestEncoding]] options:NSJSONReadingMutableContainers error:nil];
            }
#else
            NSData *data = [string dataUsingEncoding:[string smallestEncoding]];
            dic = [data objectFromJSONData];
#endif
            
            result = [dic objectForKey: aOriginKey];
            
//            if (aCacheKey != nil && result && ([result isKindOfClass:[NSDictionary class]] || [result isKindOfClass:[NSArray class]])) {
//                [_infoCacheDic setValue: [dic objectForKey: aOriginKey] forKey: aCacheKey];
//            }
        }
        else
        {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
            if (string != nil) {
                result = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:[string smallestEncoding]] options:NSJSONReadingMutableContainers error:nil];
                if (result == nil)
                {
                    result = string;
                }
            }
#else
            NSData *data = [string dataUsingEncoding:[string smallestEncoding]];
            result = [data objectFromJSONData];
#endif
            
//            if (aCacheKey != nil && result && ([result isKindOfClass:[NSDictionary class]] || [result isKindOfClass:[NSArray class]])) {
//                [_infoCacheDic setValue: result forKey: aCacheKey];
//            }
        }
        
        handleComplete(result);
    }errorHandler:^(MKNetworkOperation *operation, NSError *error){
        NSLog(@"Get post type Fail");
        
        handleError(error);
    }];
     
    [_netEngine enqueueOperation: op];
}

@end
