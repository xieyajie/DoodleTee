//
//  XDFinishShowViewController.m
//  DoodleTee
//
//  Created by xie yajie on 13-6-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "XDFinishShowViewController.h"

#import "AKSegmentedControl.h"

#import "LocalDefault.h"

@interface XDFinishShowViewController ()<AKSegmentedControlDelegate>
{
    AKSegmentedControl *_topSegmentControl;
    UIView *_bottomView;
}

@end

@implementation XDFinishShowViewController

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
    
    [self initTopView];
    [self initBottomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [title release];
    
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
    [bottomImgView release];
    
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
    [buttonUndo release];
    [buttonDone release];
    
    [self.view addSubview:_bottomView];
}

- (void)undoAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneAction
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFinishName object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
