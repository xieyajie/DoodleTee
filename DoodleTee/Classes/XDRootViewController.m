//
//  XDRootViewController.m
//  DoodleTee
//
//  Created by xie yajie on 13-5-28.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "XDRootViewController.h"
#import "XDPiazzaViewController.h"
#import "XDEffectViewController.h"
#import "XDSettingViewController.h"
#import "XDAccountViewController.h"
#import "XDAccountInfoViewController.h"
#import "XDShareViewController.h"
#import "XDCustomMadeViewController.h"

#import "MBProgressHUD.h"
#import "XDShareMethods.h"
#import "LocalDefault.h"

@interface XDRootViewController ()
{
    AKSegmentedControl *_topView;
    UIView *_bottomView;
    UIButton *_addButton;
    UIButton *_buttonPiazza;
    UIButton *_buttonShare;
    UIButton *_buttonEffect;
    
    UIImageView *_clotheView;
    NSString *_clotheImageName;
    
    UITapGestureRecognizer *_tapGesture;
}

@property (nonatomic, strong) UIImageView *effectImgView;

@end

@implementation XDRootViewController

@synthesize effectImgView = _effectImgView;

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
    
    _topView = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(20, self.viewX + 10, self.view.frame.size.width - 40, 42.5)];
    _topView.tag = kTagTopView;
    [_topView setSegmentedControlMode: AKSegmentedControlModeButton];
    [_topView setDelegate:self];
    [self initTopSegmentedView];
    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomHeight, self.view.frame.size.width, kBottomHeight)];
    UIImageView *bottomImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomBarBg.png"]];
    bottomImgView.frame = CGRectMake(0, 0, _bottomView.frame.size.width, _bottomView.frame.size.height);
    [_bottomView addSubview:bottomImgView];
    [self initBottomSegmentedView];
    [self.view addSubview:_bottomView];

    _bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomView.layer.shadowOpacity = 1.0;
    _bottomView.layer.shadowRadius = 10.0;
    _bottomView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    _clotheImageName = [XDShareMethods clotheImageName];
    
    _clotheView = [[UIImageView alloc] init];
    UIImage *image = [XDShareMethods clotheImage];
    _clotheView.frame = [self viewFrameForImage:image];
    _clotheView.image = image;
    [self.view addSubview:_clotheView];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"root_add.png"];
    _addButton.frame = [self viewFrameForImage:img];
    [_addButton setImage:img forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addEffect) forControlEvents:UIControlEventTouchUpInside];
    _addButton.hidden = YES;
    [self.view addSubview:_addButton];
    
    _addButton.hidden = NO;
    _buttonShare.enabled = NO;
    [_buttonShare setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _buttonEffect.enabled = NO;
    [_buttonEffect setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    if ([self respondsToSelector:@selector(finishedEffectWithImage:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedEffectWithImage:) name:kNotificationFinishName object:nil];
    }
    
    if ([self respondsToSelector:@selector(successOfLanding:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successOfLanding:) name:kNotificationLandSuccess object:nil];
    }
    
    if ([self respondsToSelector:@selector(changeClotheImage:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeClotheImage:) name:kNotificationChangeClotheImage object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get

- (UIImageView *)effectImgView
{
    if (_effectImgView == nil) {
        _effectImgView = [[UIImageView alloc] init];
        _effectImgView.backgroundColor = [UIColor clearColor];
        [_clotheView addSubview:_effectImgView];
    }
    
    return _effectImgView;
}

#pragma mark - AKSegmentedControl Delegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    if (segmentedControl.tag == kTagTopView) {
        switch (index) {
            case 0:
                [self settingAction];
                break;
            case 1:
                [self accountAction];
                break;
                
            default:
                break;
        }
    }
    else if (segmentedControl.tag == kTagBottomView)
    {
        switch (index) {
            case 0:
                [self piazzaAction];
                break;
            case 1:
                [self shareAction];
                break;
            case 2:
                [self effectAction];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -  NSNotificationCenter

- (void)finishedEffectWithImage:(NSNotification *)aNotification
{
    _addButton.hidden = YES;
    _buttonShare.enabled = YES;
    [_buttonShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _buttonEffect.enabled = YES;
    [_buttonEffect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIImage *image = (UIImage *)[aNotification object];
    self.effectImgView.image = image;
    self.effectImgView.frame = [[XDShareMethods defaultShare] effectViewFrameWithSuperView:_clotheView];
    
    if (_tapGesture == nil) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addEffect)];
        [self.view addGestureRecognizer:_tapGesture];
    }
}

- (void)successOfLanding:(NSNotification *)aNotification
{
    XDAccountInfoViewController *infoViewController = [[XDAccountInfoViewController alloc] init];
    [XDShareMethods presentViewController:infoViewController animated:YES formViewController:self.navigationController completion:nil];
}

- (void)changeClotheImage:(NSNotification *)aNotification
{
    _clotheImageName = (NSString *)[aNotification object];
    UIImage *image = [UIImage imageNamed:_clotheImageName];
    _clotheView.frame = [self viewFrameForImage:image];
    _clotheView.image = image;
    self.effectImgView.frame = [[XDShareMethods defaultShare] effectViewFrameWithSuperView:_clotheView];
}

#pragma mark - 页面排版
- (CGRect)viewFrameForImage:(UIImage *)image
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    return CGRectMake((self.view.frame.size.width - width) / 2,
                      (self.view.frame.size.height - height - (_topView.frame.origin.y + _topView.frame.size.height) - _bottomView.frame.size.height) / 2 + (_topView.frame.origin.y + _topView.frame.size.height),
                      width, height);
}

- (void)initTopSegmentedView
{
    UIImage *backgroundImage = [UIImage imageNamed:@"functionBarBg.png"];
    [_topView setBackgroundImage:backgroundImage];
    [_topView setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [_topView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    [_topView setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"effect_segmented_pressed_left.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:10];
    UIImage *buttonBackgroundImagePressedRight = [UIImage imageNamed:@"effect_segmented_pressed_right.png"];
    
    // T恤设置
    UIButton *buttonSettings = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 170, _topView.frame.size.height)];
    buttonSettings.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonSettings.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonSettings setTitle:@"选底衫" forState:UIControlStateNormal];
    [buttonSettings setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonSettings.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonSettings setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonSettings setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    
    UIImage *buttonSettingsImageNormal = [UIImage imageNamed:@"root_account_icon.png"];
    [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateNormal];

    //账号管理
    UIButton *buttonAccount = [[UIButton alloc] initWithFrame:CGRectMake(buttonSettings.frame.origin.x + buttonSettings.frame.size.width, 0, _topView.frame.size.width - buttonSettings.frame.size.width - 7, _topView.frame.size.height)];
    buttonAccount.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonAccount.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonAccount setTitle:@"账号" forState:UIControlStateNormal];
    [buttonAccount setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonAccount.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonAccount setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonAccount setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    
    UIImage *buttonSocialImageNormal = [UIImage imageNamed:@"root_shirt_icon.png"];
    [buttonAccount setImage:buttonSocialImageNormal forState:UIControlStateNormal];
    
    [_topView setButtonsArray:@[buttonSettings, buttonAccount]];
}

- (void)initBottomSegmentedView
{
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(14, 12, _bottomView.frame.size.width - 14 * 2, 35)];
    segmentedControl.tag = kTagBottomView;
    [segmentedControl setSegmentedControlMode: AKSegmentedControlModeButton];
    [segmentedControl setDelegate:self];
    segmentedControl.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:segmentedControl];
    
    [segmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    CGFloat width = segmentedControl.frame.size.width / 3;
    
    UIImage *buttonBackgroundImagePressedLeft = [UIImage imageNamed:@"effect_segmented_pressed_left.png"];
    UIImage *buttonBackgroundImagePressedCenter = [UIImage imageNamed:@"effect_segmented_pressed_center.png"];
    UIImage *buttonBackgroundImagePressedRight = [UIImage imageNamed:@"effect_segmented_pressed_right.png"];
    
    // 广场
    _buttonPiazza = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, segmentedControl.frame.size.height)];
    _buttonPiazza.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _buttonPiazza.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [_buttonPiazza setTitle:@"广场" forState:UIControlStateNormal];
    [_buttonPiazza setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buttonPiazza.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [_buttonPiazza setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    [_buttonPiazza setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    
    UIImage *buttonSettingsImageNormal = [UIImage imageNamed:@"root_piazza_icon.png"];
    [_buttonPiazza setImage:buttonSettingsImageNormal forState:UIControlStateNormal];
    
    _buttonPiazza.enabled = NO;
    [_buttonPiazza setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //分享管理
    _buttonShare = [[UIButton alloc] initWithFrame:CGRectMake(_buttonPiazza.frame.origin.x + _buttonPiazza.frame.size.width, 0, width, segmentedControl.frame.size.height)];
    _buttonShare.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _buttonShare.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [_buttonShare setTitle:@"分享" forState:UIControlStateNormal];
    [_buttonShare.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [_buttonShare setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [_buttonShare setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
    
    UIImage *buttonShareImageNormal = [UIImage imageNamed:@"root_share_icon.png"];
    [_buttonShare setImage:buttonShareImageNormal forState:UIControlStateNormal];
    
    
    //定制
    _buttonEffect = [[UIButton alloc] initWithFrame:CGRectMake(_buttonShare.frame.origin.x + _buttonShare.frame.size.width, 0, width, segmentedControl.frame.size.height)];
    _buttonEffect.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _buttonEffect.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [_buttonEffect setTitle:@"定制" forState:UIControlStateNormal];
    [_buttonEffect.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [_buttonEffect setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [_buttonEffect setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    
    UIImage *buttonEffectImageNormal = [UIImage imageNamed:@"root_effect_icon.png"];
    [_buttonEffect setImage:buttonEffectImageNormal forState:UIControlStateNormal];
    
    [segmentedControl setButtonsArray:@[_buttonPiazza, _buttonShare, _buttonEffect]];
}

#pragma mark - button action

- (void)settingAction
{
    XDSettingViewController *settingViewController = [[XDSettingViewController alloc] init];
    settingViewController.currentClotheImageName = _clotheImageName;
    [XDShareMethods presentViewController:settingViewController animated:YES formViewController:self.navigationController completion:nil];
}

- (void)accountAction
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
    if (userName && userName.length > 0) {
        XDAccountInfoViewController *infoViewController = [[XDAccountInfoViewController alloc] init];
        [XDShareMethods presentViewController:infoViewController animated:YES formViewController:self.navigationController completion:nil];
    }
    else{
        XDAccountViewController *accountViewController = [[XDAccountViewController alloc] init];
        [XDShareMethods presentViewController:accountViewController animated:YES formViewController:self.navigationController completion:nil];
    }
}

- (void)addEffect
{
    _addButton.hidden = NO;
    _buttonShare.enabled = NO;
    [_buttonShare setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _buttonEffect.enabled = NO;
    [_buttonEffect setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    XDEffectViewController *effectViewController = [[XDEffectViewController alloc] init];
    [self.navigationController pushViewController:effectViewController animated:YES];
}

- (void)piazzaAction
{
//    //判断是否登录
//    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
//    //未登录
//    if (userName == nil || userName.length == 0) {
//        XDAccountViewController *accountViewController = [[XDAccountViewController alloc] init];
//        [XDShareMethods presentViewController:accountViewController animated:YES formViewController:self.navigationController completion:nil];
//    }
//    else{//登陆
//        XDPiazzaViewController *piazzaVC = [[XDPiazzaViewController alloc] init];
//        [self.navigationController pushViewController:piazzaVC animated:YES];
//    }
}

- (void)shareAction
{
    UIImage *finishImage = [[XDShareMethods defaultShare] composeImage:self.effectImgView.image toImage:_clotheView.image finishToView:_clotheView];
    XDShareViewController *shareViewController = [[XDShareViewController alloc] initWithShareImage:finishImage];
    [XDShareMethods presentViewController:shareViewController animated:YES formViewController:self.navigationController completion:nil];
}

- (void)effectAction
{
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent: KSETTINGPLIST];
    NSMutableDictionary *settingsDic = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
    NSMutableDictionary *settings = [settingsDic objectForKey:userName];
    if ([settings count] > 0)
    {
        UIImageView *tmpView = _clotheView;
        UIImage *finishImage = [[XDShareMethods defaultShare] composeImage:self.effectImgView.image toImage:_clotheView.image finishToView:tmpView];
        XDCustomMadeViewController *customViewController = [[XDCustomMadeViewController alloc] initWithClothImage:finishImage];
        [self.navigationController pushViewController:customViewController animated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先选择底衫" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
