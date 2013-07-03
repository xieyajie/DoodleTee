//
//  XDTemplateViewController.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDTemplateViewController.h"

#import "LocalDefault.h"

#define kViewX 20  
#define kViewWidth 280

#define kTitleY 13
#define kTitleHeight 30

#define kBottomHeight 62

@interface XDTemplateViewController ()

@end

@implementation XDTemplateViewController

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
    // Do any additional setup after loading the view from its nib.
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.image = [UIImage imageNamed:@"root_bg.png"];
    [self.view addSubview:bgView];
    [bgView release];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewX, kTitleY, kViewWidth, kTitleHeight)];
    _titleLabel.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0];
    _titleLabel.textAlignment = KTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kBottomHeight, self.view.frame.size.width, kBottomHeight)];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _bottomView.frame.size.width, kBottomHeight)];
    bg.image = [UIImage imageNamed:@"bottomBarBg.png"];
    [_bottomView addSubview:bg];
    [bg release];
    [self.view addSubview:_bottomView];
    [self configurationBottomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public

- (void)configurationBottomView
{
    
}

- (void)configurationMainView:(UIView *)view
{
    view.frame = CGRectMake(kViewX, kTitleY + kTitleHeight, kViewWidth, kScreenHeight - kBottomHeight - (kTitleY + kTitleHeight));
//    [self.view addSubview:view];
    if (view.superview)
    {
        [self.view bringSubviewToFront: view];
    }
    else
    {
        [self.view addSubview: view];
    }
    view.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
    
    [self.view bringSubviewToFront:_bottomView];
}

@end
