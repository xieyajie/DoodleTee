//
//  XDPiazzaViewController.m
//  DoodleTee
//
//  Created by xieyajie on 13-9-13.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDPiazzaViewController.h"

#import "XDPiazzaCell.h"
#import "AKSegmentedControl.h"
#import "XDCustomMadeViewController.h"

#import "MBProgressHUD.h"
#import "LocalDefault.h"

@interface XDPiazzaViewController ()<UITableViewDelegate, UITableViewDataSource, AKSegmentedControlDelegate, XDPiazzaCellDelegate>
{
    UIView *_topView;
    AKSegmentedControl *_topSegmentedControl;
    UITableView *_tableView;
    UIView *_bottomView;
    
    NSInteger _selectedType;
    NSMutableArray *_hotDataSource;
    NSMutableArray *_historyDataSource;
}

@end

@implementation XDPiazzaViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self layoutSubviews];
    
    [_topSegmentedControl setSelectedIndex:0];
    _selectedType = 0;
    [self hotAction];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    if (_selectedType == 0) {
//        return [_hotDataSource count];
//    }
//    else if (_selectedType == 1)
//    {
//        return [_historyDataSource count];
//    }
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PiazzaCell";
    XDPiazzaCell *cell = (XDPiazzaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[XDPiazzaCell alloc] initWithStyle:UITableViewCellStyleDefault size:CGSizeMake(_tableView.frame.size.width, kPIAZZA_CELL_HEIGHT) reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.indexPath = indexPath;
    cell.headerView.image = [UIImage imageNamed:@"account_userDeaultImage.png"];
    cell.nameLabel.text = @"123";
    cell.sellCount = 10000;
    cell.imageView.image = [UIImage imageNamed:@"clothe_default.png"];
    cell.buyerCount = 20;
    cell.commentCount = 5000;
    cell.praiseCount = 1000;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPIAZZA_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XDPiazzaCell *cell = (XDPiazzaCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([self respondsToSelector:@selector(piazzaCell:tapBuyAtIndexPath:)]) {
        [self piazzaCell:cell tapBuyAtIndexPath:indexPath];
    }
}

#pragma mark - AKSegmentedControl Delegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    if (segmentedControl.tag == kTagTopView) {
        _selectedType = index;
        switch (index) {
            case 0:
                [self hotAction];
                break;
            case 1:
                [self historyAction];
                break;
                
            default:
                break;
        }
    }
    else if (segmentedControl.tag == kTagBottomView)
    {
        switch (index) {
            case 0:
                [self effectAction];
                break;
            case 1:
                [self messageAction];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - XDPiazzaCell delegate

- (void)piazzaCell:(XDPiazzaCell *)piazzaCell tapBuyAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [UIImage imageNamed:@"clothe_default.png"];
    XDCustomMadeViewController *customViewController = [[XDCustomMadeViewController alloc] initWithClothImage:image];
    [self.navigationController pushViewController:customViewController animated:YES];
}

- (void)piazzaCell:(XDPiazzaCell *)piazzaCell tapCommentAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)piazzaCell:(XDPiazzaCell *)piazzaCell tapPraiseAtIndexPath:(NSIndexPath *)indexPath
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:piazzaCell];
    hud.labelFont = [UIFont boldSystemFontOfSize:20.0];
    hud.labelText = @"赞 + 1";
    [piazzaCell addSubview:hud];
    [hud show:NO];
    [hud hide:YES afterDelay:1.0f];
    
    //赞+1
    //??????
}

#pragma mark - layout subviews

- (void)initTopView
{
    _topSegmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(20, (_topView.frame.size.height - 42.5) / 2, _topView.frame.size.width - 40, 42.5)];
    _topSegmentedControl.tag = kTagTopView;
    [_topSegmentedControl setDelegate:self];
    [_topView addSubview:_topSegmentedControl];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"functionBarBg.png"];
    [_topSegmentedControl setBackgroundImage:backgroundImage];
    [_topSegmentedControl setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [_topSegmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    [_topSegmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"effect_segmented_pressed_left.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:10];
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"effect_segmented_pressed_right.png"] stretchableImageWithLeftCapWidth:35 topCapHeight:0];
    
    // 热度排行
    UIButton *buttonHot = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _topSegmentedControl.frame.size.width / 2, _topSegmentedControl.frame.size.height)];
    buttonHot.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonHot.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonHot setTitle:@"热度排行" forState:UIControlStateNormal];
    [buttonHot setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonHot.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    buttonHot.titleLabel.textAlignment = KTextAlignmentCenter;
    [buttonHot setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonHot setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [buttonHot setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    
    //我的历史
    UIButton *buttonHistory = [[UIButton alloc] initWithFrame:CGRectMake(_topSegmentedControl.frame.size.width / 2, 0, _topSegmentedControl.frame.size.width / 2 - 5, _topSegmentedControl.frame.size.height)];
    buttonHistory.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonHistory.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonHistory setTitle:@"我的历史" forState:UIControlStateNormal];
    [buttonHistory setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonHistory.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    buttonHistory.titleLabel.textAlignment = KTextAlignmentCenter;
    [buttonHistory setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonHistory setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [buttonHistory setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    
    [_topSegmentedControl setButtonsArray:@[buttonHot, buttonHistory]];
}

- (void)initBottomView
{
    UIImageView *bottomImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomBarBg.png"]];
    bottomImgView.frame = CGRectMake(0, 0, _bottomView.frame.size.width, _bottomView.frame.size.height);
    [_bottomView addSubview:bottomImgView];
    
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(14, 12, _bottomView.frame.size.width - 14 * 2, 35)];
    segmentedControl.tag = kTagBottomView;
    [segmentedControl setSegmentedControlMode: AKSegmentedControlModeButton];
    [segmentedControl setDelegate:self];
    segmentedControl.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:segmentedControl];
    [segmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    
    CGFloat width = segmentedControl.frame.size.width / 2;
    UIImage *buttonBackgroundImagePressedLeft = [UIImage imageNamed:@"effect_segmented_pressed_left.png"];
    UIImage *buttonBackgroundImagePressedRight = [UIImage imageNamed:@"effect_segmented_pressed_right.png"];
    
    //设计
    UIButton *buttonEffect = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, segmentedControl.frame.size.height)];
    buttonEffect.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    buttonEffect.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonEffect setTitle:@"设计" forState:UIControlStateNormal];
    [buttonEffect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonEffect.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonEffect setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonEffect setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    
    //消息
    UIButton *buttonMsg = [[UIButton alloc] initWithFrame:CGRectMake(buttonEffect.frame.origin.x + buttonEffect.frame.size.width, 0, width, segmentedControl.frame.size.height)];
    buttonMsg.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    buttonMsg.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonMsg setTitle:@"消息" forState:UIControlStateNormal];
    [buttonMsg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonMsg.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonMsg setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonMsg setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    
    [segmentedControl setButtonsArray:@[buttonEffect, buttonMsg]];
}

- (void)layoutSubviews
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.image = [UIImage imageNamed:@"root_bg.png"];
    [self.view addSubview:bgView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    _topView.backgroundColor = [UIColor colorWithRed:217 / 255.0 green:217 / 255.0 blue:217 / 255.0 alpha:1.0];
    _topView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _topView.layer.shadowOpacity = 5.0;
    _topView.layer.shadowRadius = 10.0;
    _topView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.view addSubview:_topView];
    [self initTopView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 62.5, self.view.frame.size.width, 62.5)];
    _bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomView.layer.shadowOpacity = 1.0;
    _bottomView.layer.shadowRadius = 10.0;
    _bottomView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.view addSubview:_bottomView];
    [self initBottomView];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width - 20, self.view.frame.size.height - (_topView.frame.origin.y + _topView.frame.size.height) - _bottomView.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor grayColor];
    _tableView.alpha = 0.5;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

#pragma mark - button action

- (void)hotAction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)historyAction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)messageAction
{
    
}

- (void)effectAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
