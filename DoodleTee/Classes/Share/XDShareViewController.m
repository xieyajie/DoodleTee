//
//  XDShareViewController.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDShareViewController.h"

#import <ShareSDK/ShareSDK.h>

#define kSharePlistName @"share"

#define kShareKeyIcon @"icon"
#define kShareKeyName @"name"
#define kShareKeySelector @"selector"

#define SHARE_CONTENT @"这是我设计的T恤，分享一下……"

@interface XDShareViewController ()
{
    NSArray *_dataSource;
}

@property (nonatomic, retain) NSArray *dataSource;

@end

@implementation XDShareViewController

@synthesize dataSource = _dataSource;

@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self readInfoFromPlist];
    
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
    SEL method = NSSelectorFromString(sn);
    [self performSelector:method];
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
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: CellIdentifier] autorelease];
    }
    
    NSDictionary *infoDic = [_dataSource objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[infoDic objectForKey:kShareKeyIcon]];
    cell.textLabel.text = [infoDic objectForKey:kShareKeyName];
        
    return cell;
}

#pragma mark - 读取plist文件

- (void)readInfoFromPlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kSharePlistName ofType:@"plist"];
    _dataSource = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

#pragma mark - share methods

- (void)shareWithSina
{
    //创建分享内容
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:IMAGE_NAME ofType:IMAGE_EXT];
    id<ISSContent> publishContent = [ShareSDK content:SHARE_CONTENT
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:@"clothe_default.png"]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
//    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(@"发表成功");
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                                 }
                             }];
}

- (void)shareWithQQ
{
    
}

- (void)shareWithRenren
{
    
}

- (void)shareWithTencetWeibo
{
    
}

#pragma mark - public

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}


@end
