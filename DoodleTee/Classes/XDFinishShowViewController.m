//
//  XDFinishShowViewController.m
//  DoodleTee
//
//  Created by xie yajie on 13-6-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "XDFinishShowViewController.h"
#import "XDAccountViewController.h"
#import "AKSegmentedControl.h"

#import "XDDataCenter.h"
#import "XDShareMethods.h"
#import "MBProgressHUD.h"

#import "LocalDefault.h"

@interface XDFinishShowViewController ()<AKSegmentedControlDelegate>
{
    AKSegmentedControl *_topSegmentControl;
    UIView *_bottomView;
    
    UIImage *_clothImage;
    
    NSDateFormatter *_dateFormatter;
}

@property (nonatomic, strong) UIImage *clothImage;

@end

@implementation XDFinishShowViewController

@synthesize clothImage = _clothImage;

- (id)initWithClothImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        // Custom initialization
        _clothImage = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dateFormatter = [[NSDateFormatter alloc] init ];
    _dateFormatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.image = [UIImage imageNamed:@"root_bg.png"];
    [self.view addSubview:bgView];
    
    
    UIImageView *clotheView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"clothe_default.png"];
    clotheView.frame = [self frameForImage:image addToView:self.view];
    clotheView.image = [[XDShareMethods defaultShare] composeImage:_clothImage toImage:image finishToView:clotheView];
    self.clothImage = clotheView.image;
    [self.view addSubview:clotheView];
    
    [self initTopView];
    [self initBottomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - imagePicker delegate

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *info;
    if (error != NULL)
    {
        info = @"图片保存失败";
        
    }
    else  // No errors
    {   info = @"图片保存成功";
    }
    
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: info message: nil delegate:self cancelButtonTitle: @"确定" otherButtonTitles:nil, nil];
    
    [errorAlert show];
}

#pragma mark - AKSegmentedControl Delegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            [self undoAction];
            break;
        case 1:
            [self doneAction];
            break;
            
        default:
            break;
    }
}

#pragma mark - 

- (CGRect)frameForImage:(UIImage *)image addToView:(UIView *)view
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    return CGRectMake((view.frame.size.width - width) / 2,
                      (view.frame.size.height - height - (_topSegmentControl.frame.origin.y + _topSegmentControl.frame.size.height) - _bottomView.frame.size.height) / 2 + (_topSegmentControl.frame.origin.y + _topSegmentControl.frame.size.height),
                      width, height);
}


#pragma mark - private

- (void)initTopView
{
    UIImage *backgroundImage = [UIImage imageNamed:@"functionBarBg.png"];
    
    _topSegmentControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 42.5)];
    [_topSegmentControl setBackgroundImage:backgroundImage];
    [_topSegmentControl setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [_topSegmentControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, _topSegmentControl.frame.size.width, _topSegmentControl.frame.size.height - 12 * 2)];
    title.font = [UIFont systemFontOfSize:18];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"这是您设计的T恤衫";
    [_topSegmentControl addSubview:title];
    
    [self.view addSubview:_topSegmentControl];
}

- (void)initBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 62.5, self.view.frame.size.width, 62.5)];
    _bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomView.layer.shadowOpacity = 1.0;
    _bottomView.layer.shadowRadius = 10.0;
    _bottomView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    UIImageView *bottomImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomBarBg.png"]];
    bottomImgView.frame = CGRectMake(0, 0, _bottomView.frame.size.width, _bottomView.frame.size.height);
    [_bottomView addSubview:bottomImgView];
    
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(14, 12, _bottomView.frame.size.width - 14 * 2, 35)];
    [segmentedControl setSegmentedControlMode: AKSegmentedControlModeButton];
    [segmentedControl setDelegate:self];
    segmentedControl.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:segmentedControl];
    
    CGFloat width = segmentedControl.frame.size.width / 2;
    [segmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    
    //重来
    UIButton *buttonUndo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, segmentedControl.frame.size.height)];
    buttonUndo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonUndo.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonUndo setTitle:@"重来" forState:UIControlStateNormal];
    [buttonUndo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonUndo.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonUndo setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    UIImage *buttonUndoNormal = [UIImage imageNamed:@"effect_image_icon.png"];
    [buttonUndo setImage:buttonUndoNormal forState:UIControlStateNormal];
    
    //完成
    UIButton *buttonDone = [[UIButton alloc] initWithFrame:CGRectMake(buttonUndo.frame.origin.x + buttonUndo.frame.size.width, 0, width, segmentedControl.frame.size.height)];
    buttonDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonDone.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonDone setTitle:@"完成" forState:UIControlStateNormal];
    [buttonDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonDone.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonDone setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    UIImage *buttonDoneNormal = [UIImage imageNamed:@"effect_image_icon.png"];
    [buttonDone setImage:buttonDoneNormal forState:UIControlStateNormal];
    
    [segmentedControl setButtonsArray:@[buttonUndo, buttonDone]];
    
    [self.view addSubview:_bottomView];
}

- (NSString *)saveImage:(UIImage *)image imageName:(NSString *)imgName userName:(NSString *)userName
{
    //将图片存到本地沙盒内
    NSString *tmpPath = [NSString stringWithFormat:@"%@%@/", kLocalImagePath, userName];
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
        //将图片存到本地相册
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        return imgName;
    }
    
    return imgName;
}

- (void)uploadImage:(UIImage *)image userName:(NSString *)userName
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *imgName = [NSString stringWithFormat:@"%@_%@.png", userName, [_dateFormatter stringFromDate:[NSDate date]]];
    //上传图片到服务器
    NSString *imgPath = [self saveImage:self.clothImage imageName:imgName userName:userName];
    [[XDDataCenter sharedCenter] uploadImageWithPath:imgPath userName:userName complete:^(id result){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (result && [result isKindOfClass:[NSString class]]) {
            NSLog(@"server response: %@",result);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFinishName object:self.clothImage];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }onError:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Upload file error: %@", error);
    }];
}

- (void)undoAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneAction
{
    //判断是否登录
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
    //未登录
    if (userName == nil && userName.length == 0) {
        XDAccountViewController *accountViewController = [[XDAccountViewController alloc] init];
        [self.navigationController presentViewController:accountViewController animated:YES completion:nil];
    }
    else{//登陆
        [self uploadImage:self.clothImage userName:userName];
    }
}

@end
