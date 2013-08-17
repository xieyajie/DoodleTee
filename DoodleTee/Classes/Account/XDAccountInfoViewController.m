//
//  XDAccountInfoViewController.m
//  DoodleTee
//
//  Created by xie yajie on 13-7-4.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "XDAccountInfoViewController.h"

#import "XDAccountInfoCell.h"
#import "AKSegmentedControl.h"

#import "LocalDefault.h"

@interface XDAccountInfoViewController ()<UITableViewDataSource, UITableViewDelegate, AKSegmentedControlDelegate>
{
    NSMutableArray *_headerViews;
    NSArray *_headerTitles;
    NSMutableArray *_selectedSections;
}

@end

@implementation XDAccountInfoViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _headerViews = [[NSMutableArray alloc] init];
        _headerTitles = [[NSArray alloc] initWithObjects:kACCOUNTCONSIGNEE, kACCOUNTPAY, kACCOUNTDESIGN, kACCOUNTBUY, kACCOUNTSELL, nil];
        _selectedSections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.image = [UIImage imageNamed:@"root_bg.png"];
    [self.view addSubview:bgView];
    
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
    [self layoutHeaderViews];
    _tableView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomView.layer.shadowOpacity = 1.0;
    _bottomView.layer.shadowRadius = 8.0;
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
    return 7;
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
                return 1;
            }
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *BasicCellIdentifier = @"BasicCell";
        XDAccountInfoCell *cell = (XDAccountInfoCell *)[tableView dequeueReusableCellWithIdentifier:BasicCellIdentifier];
        
        if (nil == cell) {
            cell = [[XDAccountInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BasicCellIdentifier];
            [cell cellForBasicInfo];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.imageView.image = [UIImage imageNamed:@"account_userDeaultImage.png"];
        cell.nameLabel.text = @"123";
        cell.achieveLabel.text = @"456";
        cell.balanceLabel.text = @"789";
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = @"abc";
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

#pragma mark - button

- (void)moreOrLessAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        [_selectedSections addObject:[NSNumber numberWithInteger:button.tag]];
    }
    else
    {
        for (NSNumber *n in _selectedSections) {
            if ([n integerValue] == button.tag) {
                [_selectedSections removeObject:n];
                break;
            }
        }
    }
    
    [self showSection:button.tag isMore:button
     .selected];
//    switch (button.tag) {
//        case 2:
//            //
//            break;
//        case 3:
//            //
//            break;
//        case 4:
//            //
//            break;
//        case 5:
//            //
//            break;
//        case 6:
//            //
//            break;
//            
//        default:
//            break;
//    }
}

#pragma mark - private

- (void)layoutHeaderViews
{
    for (int i = 2; i < 7; i++) {
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.height, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _tableView.frame.size.width - 20, 30)];
    colorLabel.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    [headerView addSubview:colorLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:titleLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_tableView.frame.size.width - 10 - 25, 5, 20, 20)];
    button.tag = section;
    [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(moreOrLessAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    [_headerViews addObject:headerView];
}

- (void)showSection:(NSInteger)section isMore:(BOOL)isMore
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    [_tableView beginUpdates];
    if (isMore) {
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
    else{
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
    [_tableView endUpdates];
}

- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logoutAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUserName];
    [self backAction:sender];
}


@end
