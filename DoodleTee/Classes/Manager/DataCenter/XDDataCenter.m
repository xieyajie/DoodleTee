//
//  XDDataCenter.m
//  New
//
//  Created by ed on 12-9-11.
//
//
#import "XDDataCenter.h"

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
    NSString *path = [NSString stringWithFormat: @"%@UserName=%@&UserPWD=%@&Name=%@&Tel=%@&Address=%@", kRegisterAddress, aUserName, aPassword, aRealName, aTel, aAddress];
    [self requestInfo: path andOriginKey:nil andCacheKey:nil andRequestKey:kRequestRegisterKey onComplete: handleComplete onError: handleError];
}

- (void)loginWithUserName:(NSString *)aUserName password:(NSString *)aPassword complete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError
{
    NSString *path = [NSString stringWithFormat: @"%@UserName=%@&UserPWD=%@", kLoginAddress, aUserName, aPassword];
    [self requestInfo: path andOriginKey:nil andCacheKey:nil andRequestKey:kRequestLoginKey onComplete: handleComplete onError: handleError];
}

- (void)uploadImage:(UIImage *)aImage imageName:(NSString *)aImageName userName:(NSString *)aUserName complete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError
{
    
}

- (void)orderWithUserName:(NSString *)aUserName colcor:(NSString *)aColor material:(NSString *)aMaterial size:(NSString *)aSize brand:(NSString *)aBrand count:(NSInteger)aCount money:(CGFloat)aMoney complete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError
{
    NSString *path = [NSString stringWithFormat: @"%@UserName=%@&Color=%@&Material=%@&Size=%@&Brand=%@&Number=%i&Money=%f", kOrderAddress, aUserName, aColor, aMaterial, aSize, aBrand, aCount, aMoney];
    [self requestInfo: path andOriginKey:nil andCacheKey:nil andRequestKey:nil onComplete: handleComplete onError: handleError];
}


#pragma mark - Private methods

- (void)requestInfo:(NSString*)aPath andOriginKey:(NSString*)aOriginKey andCacheKey:(NSString*)aCacheKey andRequestKey:(NSString*)aRequestKey onComplete:(XDCompleteBlock)handleComplete onError:(XDErrorBlock)handleError
{
    MKNetworkOperation *op= [_netEngine operationWithPath: aPath];
    
//    if (aRequestKey != nil)
//    {
//        NSMutableArray *array = [_requestDic objectForKey: aRequestKey];
//        if (array == nil)
//        {
//            array = [[NSMutableArray alloc] init];
//            [_requestDic setObject: array forKey: aRequestKey];
//            [array addObject: op];
//            [array release];
//        }
//        else{
//            [array addObject: op];
//        }
//    }
    
    [op addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"Get post type Success");
        
        id resultData;
        if (nil != aOriginKey)
        {
            NSDictionary *dic = [operation responseJSON];
            
//            [_infoCacheDic setValue: [dic objectForKey: aOriginKey] forKey: aCacheKey];
            
            resultData = [dic objectForKey: aOriginKey];
        }
        else
        {
//            [_infoCacheDic setValue: resultData forKey: aCacheKey];
            
            resultData = [operation responseJSON];
        }
        
        handleComplete(resultData);
    }errorHandler:^(MKNetworkOperation *operation, NSError *error){
        NSLog(@"Get post type Fail");
        
        handleError(error);
    }];
     
    [_netEngine enqueueOperation: op];
}

@end
