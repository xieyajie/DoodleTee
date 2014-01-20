//
//  XDCommentViewController.m
//  DoodleTee
//
//  Created by xieyajie on 13-9-16.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDCommentViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "XDNewCommentViewController.h"
#import "XDCustomMadeViewController.h"
#import "XDPiazzaCommentCell.h"
#import "MBProgressHUD.h"
#import "LocalDefault.h"

@interface XDCommentViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_dataSource;
    
    UILabel *_topLabel;
    UITableView *_tableView;
    UIView *_operateView;
    UIView *_bottomView;
}

@end

@implementation XDCommentViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] initWithObjects:@"这件设计的不错", @"这件设计的不错这件设计的不错这件设计的不错", @"这件设计的不错这件设计的不错这件设计的不错这件设计的不错这件设计的不错", @"这件设计的不错这件设计的不错这件设计的不错这件设计的不错这件设计的不错这件设计的不错这件设计的不错这件设计的不错", @"这件设计的不错这件设计的不错这件设计的不错这件设计的不错这件设计的不错这件设计的不错这件设计的不错这件设计的不错这件设计的不错这件设计的不错", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 31)];
    _topLabel.font = [UIFont systemFontOfSize:18];
    _topLabel.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0];
    _topLabel.textAlignment = KTextAlignmentCenter;
    _topLabel.text = @"评论";
    _topLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    _topLabel.layer.shadowOpacity = 5.0;
    _topLabel.layer.shadowRadius = 10.0;
    _topLabel.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.view addSubview:_topLabel];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomHeight, self.view.frame.size.width, kBottomHeight)];
    UIImageView *bottomImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomBarBg.png"]];
    bottomImgView.frame = CGRectMake(0, 0, _bottomView.frame.size.width, _bottomView.frame.size.height);
    [_bottomView addSubview:bottomImgView];
    [self.view addSubview:_bottomView];
    _bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomView.layer.shadowOpacity = 1.0;
    _bottomView.layer.shadowRadius = 10.0;
    _bottomView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.view addSubview:_bottomView];
    
    // 返回
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(12, 10, _bottomView.frame.size.width - 12 - 11, 42)];
    buttonBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    buttonBack.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBack.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonBack setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"functionBarBg.png"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:buttonBack];
    
    _operateView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - _bottomView.frame.size.height - 40, self.view.frame.size.width, 40.0)];
    _operateView.backgroundColor = [UIColor grayColor];
//    _operateView.alpha = 0.7;
    [self.view addSubview:_operateView];
    
    CGFloat width = (_bottomView.frame.size.width - 4 * 5) / 3;
    UIButton *buyerBt = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, width, _operateView.frame.size.height)];
    buyerBt.titleLabel.textAlignment = KTextAlignmentCenter;
    buyerBt.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [buyerBt addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    [buyerBt setTitle:@"￥20.0 购买" forState:UIControlStateNormal];
    [_operateView addSubview:buyerBt];
    
    UIButton *commentBt = [[UIButton alloc] initWithFrame:CGRectMake(width + 5 * 2, 0, width, _operateView.frame.size.height)];
    commentBt.titleLabel.textAlignment = KTextAlignmentCenter;
    commentBt.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [commentBt addTarget:self action:@selector(newCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentBt setTitle:@"+ 评论" forState:UIControlStateNormal];
    [_operateView addSubview:commentBt];
    
    UIButton *praiseBt = [[UIButton alloc] initWithFrame:CGRectMake((width + 5) * 2 + 5, 0, width, _operateView.frame.size.height)];
    praiseBt.titleLabel.textAlignment = KTextAlignmentCenter;
    praiseBt.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [praiseBt addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    [praiseBt setTitle:@"赞 1k+" forState:UIControlStateNormal];
    [_operateView addSubview:praiseBt];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topLabel.frame.origin.y + _topLabel.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (_topLabel.frame.origin.y + _topLabel.frame.size.height) - _operateView.frame.size.height - _bottomView.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
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
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    XDPiazzaCommentCell *cell = (XDPiazzaCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[XDPiazzaCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.headerView.image = [UIImage imageNamed:@"account_userDeaultImage.png"];
    cell.nameLabel.text = @"123";
    cell.dateLabel.text = @"2013/09/13";
    cell.content = [_dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Tabel view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 80;
    NSString *str = [_dataSource objectAtIndex:indexPath.row];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(280, 500) lineBreakMode:NSLineBreakByWordWrapping];
    height += size.height > 30 ? size.height : 30;
    return height;
}

#pragma mark - button action

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buyAction:(id)sender
{
    XDCustomMadeViewController *customViewController = [[XDCustomMadeViewController alloc] initWithClothInfo:nil];
    [self.navigationController pushViewController:customViewController animated:YES];
}

- (void)newCommentAction:(id)sender
{
    XDNewCommentViewController *newCommentVC = [[XDNewCommentViewController alloc] init];
    [self.navigationController pushViewController:newCommentVC animated:YES];
}

- (void)praiseAction:(id)sender
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont boldSystemFontOfSize:20.0];
    hud.labelText = @"赞 + 1";
    [self.view addSubview:hud];
    [hud show:NO];
    [hud hide:YES afterDelay:1.0f];
    
    //赞+1
    //??????
}

@end
