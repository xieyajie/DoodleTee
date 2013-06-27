//
//  XDRootViewController.m
//  DoodleTee
//
//  Created by xie yajie on 13-5-28.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDRootViewController.h"

#import "XDEffectViewController.h"

#import "XDSettingViewController.h"

#import "XDAccountViewController.h"

#import "LocalDefault.h"

#define kTagTopView 0
#define kTagBottomView 1

@interface XDRootViewController ()
{
    AKSegmentedControl *_topView;
    UIView *_bottomView;
    UIButton *_addButton;
    
    UIImageView *_clotheView;
}

@end

@implementation XDRootViewController

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
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.image = [UIImage imageNamed:@"root_bg.png"];
    [self.view addSubview:bgView];
    [bgView release];
    
    _topView = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 42.5)];
    _topView.tag = kTagTopView;
    [_topView setSegmentedControlMode: AKSegmentedControlModeButton];
    [_topView setDelegate:self];
    [self initTopSegmentedView];
    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 62.5, self.view.frame.size.width, 62.5)];
    UIImageView *bottomImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomBarBg.png"]];
    bottomImgView.frame = CGRectMake(0, 0, _bottomView.frame.size.width, _bottomView.frame.size.height);
    [_bottomView addSubview:bottomImgView];
    [bottomImgView release];
    [self initBottomSegmentedView];
    [self.view addSubview:_bottomView];

    _bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomView.layer.shadowOpacity = 1.0;
    _bottomView.layer.shadowRadius = 10.0;
    _bottomView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    _clotheView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"clothe_default.png"];
    _clotheView.frame = [self viewFrameForImage:image];
    _clotheView.image = image;
    [self.view addSubview:_clotheView];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"root_add.png"];
    _addButton.frame = [self viewFrameForImage:img];
    [_addButton setImage:img forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addEffect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addButton];
    
    if ([self respondsToSelector:@selector(finishedEffectWithImage:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedEffectWithImage:) name:kNotificationFinishName object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    _clotheView.image = 
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
    [buttonSettings release];
    [buttonAccount release];
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
    UIButton *buttonSettings = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, segmentedControl.frame.size.height)];
    buttonSettings.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonSettings.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonSettings setTitle:@"广场" forState:UIControlStateNormal];
    [buttonSettings setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonSettings.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonSettings setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    [buttonSettings setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    
    UIImage *buttonSettingsImageNormal = [UIImage imageNamed:@"root_piazza_icon.png"];
    [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateNormal];
    
    //分享管理
    UIButton *buttonShare = [[UIButton alloc] initWithFrame:CGRectMake(buttonSettings.frame.origin.x + buttonSettings.frame.size.width, 0, width, segmentedControl.frame.size.height)];
    buttonShare.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonShare.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonShare setTitle:@"分享" forState:UIControlStateNormal];
    [buttonShare setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttonShare.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonShare setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    [buttonShare setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
    
    UIImage *buttonShareImageNormal = [UIImage imageNamed:@"root_share_icon.png"];
    [buttonShare setImage:buttonShareImageNormal forState:UIControlStateNormal];
    buttonShare.enabled = NO;
    
    //定制
    UIButton *buttonEffect = [[UIButton alloc] initWithFrame:CGRectMake(buttonSettings.frame.origin.x + buttonSettings.frame.size.width, 0, width, segmentedControl.frame.size.height)];
    buttonEffect.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonEffect.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonEffect setTitle:@"定制" forState:UIControlStateNormal];
    [buttonEffect setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttonEffect.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonEffect setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    [buttonEffect setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    
    UIImage *buttonEffectImageNormal = [UIImage imageNamed:@"root_effect_icon.png"];
    [buttonEffect setImage:buttonEffectImageNormal forState:UIControlStateNormal];
    buttonEffect.enabled = NO;
    
    [segmentedControl setButtonsArray:@[buttonSettings, buttonShare, buttonEffect]];
    [buttonSettings release];
    [buttonShare release];
    [buttonEffect release];
}

#pragma mark - button action

- (void)settingAction
{
    XDSettingViewController *settingViewController = [[XDSettingViewController alloc] init];
    [self.navigationController presentViewController:settingViewController animated:YES completion:nil];
    [settingViewController release];
}

- (void)accountAction
{
    XDAccountViewController *accountViewController = [[XDAccountViewController alloc] init];
    [self.navigationController presentViewController:accountViewController animated:YES completion:nil];
    [accountViewController release];
}

- (void)addEffect
{
    XDEffectViewController *effectViewController = [[XDEffectViewController alloc] init];
    [self.navigationController pushViewController:effectViewController animated:YES];
    [effectViewController release];
}

- (void)piazzaAction
{
     NSLog(@"piazza");
}

- (void)shareAction
{
     NSLog(@"share");
}

- (void)effectAction
{
     NSLog(@"effect");
}

@end
