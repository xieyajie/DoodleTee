//
//  XDAccountInfoViewController.m
//  DoodleTee
//
//  Created by xie yajie on 13-7-4.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "XDAccountInfoViewController.h"
#import "XDAccountInfoHeaderView.h"
#import "XDAccountInfoCell.h"
#import "AKSegmentedControl.h"

#import "XDShareMethods.h"
#import "LocalDefault.h"

#define kMoreButtonTag 100

@interface XDAccountInfoViewController ()<UITableViewDataSource, UITableViewDelegate, AKSegmentedControlDelegate, XDAccountInfoHeaderViewDelegate>
{
    NSMutableArray *_headerViews;
    NSArray *_headerTitles;
    NSMutableArray *_selectedSections;
    
    UIImage *_headerImage;
    
    NSMutableDictionary *_dataSource;
}

@end

@implementation XDAccountInfoViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableArray array], kACCOUNTCONSIGNEE, [NSMutableArray array], kACCOUNTPAY, [NSArray array], kACCOUNTDESIGN, [NSArray array], kACCOUNTDESIGN, [NSArray array], kACCOUNTSELL, nil];
        _headerViews = [[NSMutableArray alloc] init];
        _headerTitles = [[NSArray alloc] initWithObjects:kACCOUNTCONSIGNEE, kACCOUNTPAY, kACCOUNTDESIGN, kACCOUNTBUY, kACCOUNTSELL, nil];
        _selectedSections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutHeaderViews];
    
    [self getLocalDataSource];
    [self requestDataSource];
    
    _headerImage = [XDShareMethods getSinaIconFromLocal];
    if (_headerImage == nil) {
        _headerImage = [UIImage imageNamed:@"account_userDeaultImage.png"]; 
    }
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewX, kTitleY, kViewWidth, kTitleHeight)];
    _titleLabel.textAlignment = KTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0];
    _titleLabel.text = @"账户";
    [self.view addSubview:_titleLabel];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomHeight, self.view.frame.size.width, kBottomHeight)];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _bottomView.frame.size.width, kBottomHeight)];
    bg.contentMode = UIViewContentModeScaleAspectFit;
    bg.image = [UIImage imageNamed:@"bottomBarBg.png"];
    [_bottomView addSubview:bg];
    [self layoutBottomView];
    [self.view addSubview:_bottomView];
    
    CGFloat y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height;
    CGRect rect = CGRectMake(_titleLabel.frame.origin.x, y, _titleLabel.frame.size.width, _bottomView.frame.origin.y - y);
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomView.layer.shadowOpacity = 1.0;
    _bottomView.layer.shadowRadius = 5.0;
    _bottomView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.view bringSubviewToFront:_bottomView];
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
    return [_dataSource count] + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section < 2) {
        return 1;
    }
    else{
        for (NSNumber *n in _selectedSections) {
            if ([n integerValue] == section) {
                XDAccountInfoHeaderView *headView = [_headerViews objectAtIndex:(section - 2)];
                NSInteger count = [[_dataSource objectForKey:headView.title] count];
                if (count == 0) {
                    count = 1;
                }
                return count;
            }
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *HeaderCellIdentifier = @"HeaderCell";
        XDAccountInfoCell *headerCell = (XDAccountInfoCell *)[tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
        
        if (nil == headerCell) {
            headerCell = [[XDAccountInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeaderCellIdentifier];
            [headerCell cellForHeaderView];
            headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        headerCell.headerView.image = _headerImage;
        headerCell.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
        headerCell.achieveLabel.text = @"暂无";
        headerCell.balanceLabel.text = @"暂无";
        
        return headerCell;
    }
    else if (indexPath.section == 1){
        static NSString *DynamicCellIdentifier = @"DynamicCell";
        XDAccountInfoCell *dynamicCell = (XDAccountInfoCell *)[tableView dequeueReusableCellWithIdentifier:DynamicCellIdentifier];
        
        if (nil == dynamicCell) {
            dynamicCell = [[XDAccountInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DynamicCellIdentifier];
            [dynamicCell cellForLineChart];
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        dynamicCell.textLabel.text = @"暂无动态";
        
        return dynamicCell;
    }
    else if (indexPath.section == 2 || indexPath.section == 3)
    {
        static NSString *ConsigneeCellIdentifier = @"ConsigneeCell";
        XDAccountInfoCell *consigneeCell = (XDAccountInfoCell *)[tableView dequeueReusableCellWithIdentifier:ConsigneeCellIdentifier];
        
        if (nil == consigneeCell) {
            consigneeCell = [[XDAccountInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ConsigneeCellIdentifier];
            [consigneeCell cellForConsigne];
            consigneeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString *key = [_headerTitles objectAtIndex:(indexPath.section - 2)];
        NSArray *array = [_dataSource objectForKey:key];
        if (array && array.count > 0) {
            NSDictionary *dic = [array objectAtIndex:indexPath.row];
            if (dic && [dic count] > 0) {
                XDShareMethods *tool = [XDShareMethods defaultShare];
                consigneeCell.consigneTitleLabel.text = [NSString stringWithFormat:@"%@:", [tool chineseForString:[dic objectForKey:kAccountConsigneTitle]]];
                consigneeCell.consigneInfoLabel.text = [tool chineseForString:[dic objectForKey:kAccountInfo]];
            }
        }
        else{
            consigneeCell.consigneInfoLabel.text = @"";
            consigneeCell.consigneTitleLabel.text = @"";
            consigneeCell.textLabel.text = @"暂无信息";
        }
        
        return consigneeCell;
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"暂无信息";
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 100;
            break;
        case 1:
            return 100;
            break;
            
        default:
            return 50;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < 2) {
        return 0;
    }
    else{
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 1) {
        return [_headerViews objectAtIndex:(section - 2)];
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - AKSegmentedControl Delegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            [self backAction:nil];
            break;
        case 1:
            [self logoutAction:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - XDAccountInfoHeaderViewDelegate

- (void)headerView:(XDAccountInfoHeaderView *)headerView showMoreInfo:(BOOL)open
{
    NSInteger section = headerView.section;
    if (open) {
        [_selectedSections addObject:[NSNumber numberWithInteger:section]];
    }
    else
    {
        for (NSNumber *n in _selectedSections) {
            if ([n integerValue] == section) {
                [_selectedSections removeObject:n];
                break;
            }
        }
    }
    
    [self showSection:section isMore:open];
}

#pragma mark - data source

- (void)getLocalDataSource
{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
    
    //获取常用联系人信息
    NSString *consigneeTmp = [NSString stringWithFormat:@"%@/%@/%@", kLocalDocuments, userName, kLocalInfoPlistName];
    NSString *consigneePath = [NSHomeDirectory() stringByAppendingPathComponent: consigneeTmp];
    if ([fileManage fileExistsAtPath: consigneePath])
    {
        NSMutableDictionary *consigneeDic = [[NSMutableDictionary dictionaryWithContentsOfFile:consigneePath] objectForKey:userName];
        if ([consigneeDic count] != 0) {
            NSMutableDictionary *consigneeInfo = [NSMutableDictionary dictionaryWithDictionary:[consigneeDic objectForKey:[[consigneeDic allKeys] objectAtIndex:0]]];
            
            NSMutableArray *array1 = [NSMutableArray array];
            NSMutableArray *array2 = [NSMutableArray array];
            for (NSString *key in consigneeInfo) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[consigneeInfo objectForKey:key], kAccountInfo, key, kAccountConsigneTitle, nil];
                
                if ([key isEqualToString:kORDERPAYMENT]) {
                    [array1 addObject:dic];
                    continue;
                }
                
                [array2 addObject:dic];
            }
            
            [_dataSource setObject:array1 forKey:kACCOUNTPAY];
            [_dataSource setObject:array2 forKey:kACCOUNTCONSIGNEE];
        }
    }
}

- (void)requestDataSource
{
    
}

#pragma mark - private

- (void)layoutHeaderViews
{
    for (int i = 2; i < [_dataSource count] + 2; i++) {
        [self headerViewWithTitle:[_headerTitles objectAtIndex:(i - 2)] section:i];
    }
}

- (void)layoutBottomView
{
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(14, 12, _bottomView.frame.size.width - 14 * 2, 35)];
    [segmentedControl setSegmentedControlMode: AKSegmentedControlModeButton];
    [segmentedControl setDelegate:self];
    segmentedControl.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:segmentedControl];
    [segmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    
    CGFloat width = segmentedControl.frame.size.width / 2;
    UIImage *buttonBackgroundImagePressedLeft = [UIImage imageNamed:@"effect_segmented_pressed_left.png"];
    UIImage *buttonBackgroundImagePressedRight = [UIImage imageNamed:@"effect_segmented_pressed_right.png"];
    
    // 返回
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, segmentedControl.frame.size.height)];
    buttonBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    buttonBack.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBack.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonBack setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonBack setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    
    //注销
    UIButton *buttonLogout = [[UIButton alloc] initWithFrame:CGRectMake(buttonBack.frame.origin.x + buttonBack.frame.size.width, 0, width, segmentedControl.frame.size.height)];
    buttonLogout.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    buttonLogout.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonLogout setTitle:@"注销" forState:UIControlStateNormal];
    [buttonLogout setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonLogout.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonLogout setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonLogout setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [segmentedControl setButtonsArray:@[buttonBack, buttonLogout]];
}

- (void)headerViewWithTitle:(NSString *)title section:(NSInteger)section
{
    XDAccountInfoHeaderView *headerView = [[XDAccountInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 30)];
    headerView.delegate = self;
    headerView.title = title;
    headerView.section = section;
    
    [_headerViews addObject:headerView];
}

- (void)showSection:(NSInteger)section isMore:(BOOL)isMore
{
    [_tableView beginUpdates];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
}

- (void)backAction:(id)sender
{
    [XDShareMethods dismissViewController:self animated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logoutAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUserName];
    [self backAction:sender];
}


@end
