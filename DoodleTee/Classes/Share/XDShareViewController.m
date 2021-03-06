//
//  XDShareViewController.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDShareViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "XDShareMethods.h"
#import "LocalDefault.h"

#define kSharePlistName @"share"

#define kShareKeyIcon @"icon"
#define kShareKeyName @"name"
#define kShareKeySelector @"selector"

#define SHARE_CONTENT @"这是我设计的T恤，分享一下……"

@interface XDShareViewController ()
{
    NSArray *_dataSource;  //分享平台信息
    
    UIImage *_shareImage;  //要分享的图片
    
    id<ISSContent> _publishContent; //分享内容
    
    id<ISSShareOptions> _shareOptions; //分享选项，用于定义分享视图部分属性（如：标题、一键分享列表、功能按钮等）,默认可传入nil
}

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UIImage *shareImage;

@property (nonatomic, strong) id<ISSContent> publishContent;

@property (nonatomic, strong) id<ISSShareOptions> shareOptions;

@end

@implementation XDShareViewController

@synthesize dataSource = _dataSource;

@synthesize tableView = _tableView;

@synthesize shareImage = _shareImage;

@synthesize publishContent = _publishContent;

@synthesize shareOptions = _shareOptions;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithShareImage:(UIImage *)image
{
    self = [super init];
    if (self) {
//        _shareImage = [image retain];
        _shareImage = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self readInfoFromPlist];
    [self configurationShare];
    [self layoutSubviews];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
    NSString *sn = [dic objectForKey:kShareKeySelector];
    if (sn != nil) {
        SEL method = NSSelectorFromString(sn);
        if (method && [self respondsToSelector:method]) {
            [self performSelector:method];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: CellIdentifier];
    }
    
    NSDictionary *infoDic = [_dataSource objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[infoDic objectForKey:kShareKeyIcon]];
    cell.textLabel.text = [infoDic objectForKey:kShareKeyName];
        
    return cell;
}

#pragma mark - layout views

- (void)layoutSubviews
{
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.view addSubview:_toolbar];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:nil action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, titleItem, flexibleSpace, cancelItem, nil] animated:YES];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _toolbar.frame.origin.y + 44, self.view.frame.size.width, self.view.frame.size.height - (_toolbar.frame.origin.y + 44)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - 读取plist文件

- (void)readInfoFromPlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kSharePlistName ofType:@"plist"];
    _dataSource = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

#pragma mark - 配置分享内容和选项

- (void)configurationShare
{
    self.publishContent = [ShareSDK content:SHARE_CONTENT
                         defaultContent:@""
                                  image:[ShareSDK pngImageWithImage:self.shareImage]
                                  title:nil
                                    url:nil
                            description:nil
                              mediaType:SSPublishContentMediaTypeNews];
    
    self.shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"分享" shareViewDelegate:nil];
}

#pragma mark - 显示分享页面

- (void)showShareViewWithType:(ShareType)type title:(NSString *)title
{
    [_shareOptions setTitle:title];
    
    [ShareSDK showShareViewWithType:type
                          container:nil
                            content:self.publishContent
                      statusBarTips:YES
                        authOptions:nil
                       shareOptions:self.shareOptions
                             result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [self getUserInfoWithType:type];
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                                 }
                             }];
}

#pragma mark - share methods

- (void)shareWithSina
{
    [self showShareViewWithType:ShareTypeSinaWeibo title:@"分享到新浪微博"];
}
//
//- (void)shareWithQQ
//{
//    [self showShareViewWithType:ShareTypeQQSpace title:@"分享到QQ空间"];
//}
//
//- (void)shareWithRenren
//{
//    [self showShareViewWithType:ShareTypeRenren title:@"分享到人人"];
//}
//
//- (void)shareWithTencetWeibo
//{
//    [self showShareViewWithType:ShareTypeTencentWeibo title:@"分享到腾讯微博"];
//}

#pragma mark - public

- (void)getUserInfoWithType:(ShareType)shareType
{
    [ShareSDK getUserInfoWithType:shareType
                      authOptions:nil
                           result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:userInfo.icon]];
                                   [XDShareMethods saveSinaIconToLocal:data];
                               }
                               else
                               {
                                   NSLog(@"失败");
                               }
                           }];
}

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}


@end
