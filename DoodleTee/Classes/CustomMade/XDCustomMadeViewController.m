//
//  XDCustomMadeViewController.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "XDCustomMadeViewController.h"

#import "XDPayMoneyViewController.h"

#import "XDAttributeCell.h"

#import "AKSegmentedControl.h"

#import "LocalDefault.h"

#define kRowCount 5
#define kRowMoney 6

@interface XDCustomMadeViewController ()<AKSegmentedControlDelegate>
{
    NSDictionary *_attributeDic;
}

@property (nonatomic, retain) NSDictionary *attributeDic;

@end

@implementation XDCustomMadeViewController

@synthesize titleLabel = _titleLabel;

@synthesize tableView = _tableView;

@synthesize attributeDic = _attributeDic;

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
    [self configurationAttribute];
    
    _titleLabel.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0];
    
    CGFloat y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height;
    _tableView.frame = CGRectMake(_titleLabel.frame.origin.x, y, _titleLabel.frame.size.width, _bottomView.frame.origin.y - y);
    _tableView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomView.layer.shadowOpacity = 1.0;
    _bottomView.layer.shadowRadius = 10.0;
    _bottomView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 260;
    }
    else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [self configurationImageCell];
    }
    else if (indexPath.row == 5)
    {
        return [self configurationCountCell];
    }
    else if(indexPath.row == 6)
    {
        return [self configurationMoneyCell];
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        XDAttributeCell *cell = [(XDAttributeCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier] autorelease];
        
        if (nil == cell)
        {
            cell = [[XDAttributeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.title = @"123";
        cell.value = @"456";
        
        return cell;
    }
}

#pragma mark - AKSegmentedControl delegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            [self backAction];
            break;
        case 1:
            [self doneAction];
            break;
            
        default:
            break;
    }

}

#pragma mark - private

- (void)configurationAttribute
{
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent: KSETTINGPLIST];
    NSDictionary *settingDic = [[NSDictionary alloc] initWithContentsOfFile: plistPath];
    self.attributeDic = settingDic;
    [settingDic release];
}

- (UITableViewCell *)configurationImageCell
{
    static NSString *ImageCellIdentifier = @"ImageCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier: ImageCellIdentifier];
    
    if (nil == cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageCellIdentifier] autorelease];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, self.tableView.frame.size.width, 200)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"clothe_default.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];
    }
    
    return cell;
}

- (UITableViewCell *)configurationCountCell
{
    UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];
    
    UILabel *attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, cell.contentView.frame.size.height)];
    attributeLabel.backgroundColor = [UIColor clearColor];
    attributeLabel.font = [UIFont boldSystemFontOfSize:20];
    [cell.contentView addSubview:attributeLabel];
    
    attributeLabel.text = @"321";
    
    return cell;
}

- (UITableViewCell *)configurationMoneyCell
{
    UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];
    
    UILabel *attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, cell.contentView.frame.size.height)];
    attributeLabel.backgroundColor = [UIColor clearColor];
    attributeLabel.font = [UIFont boldSystemFontOfSize:20];
    [cell.contentView addSubview:attributeLabel];
    
    attributeLabel.text = @"321";
    
    return cell;
}

#pragma mark - private

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
    
    //返回
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, segmentedControl.frame.size.height)];
    buttonBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonBack.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBack.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonBack setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonBack setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    
    //提交订单
    UIButton *buttonDone = [[UIButton alloc] initWithFrame:CGRectMake(buttonBack.frame.origin.x + buttonBack.frame.size.width, 0, width, segmentedControl.frame.size.height)];
    buttonDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonDone.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonDone setTitle:@"提交订单" forState:UIControlStateNormal];
    [buttonDone.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonDone setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonDone setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    
    [segmentedControl setButtonsArray:@[buttonBack, buttonDone]];
    [buttonBack release];
    [buttonDone release];
}

- (IBAction)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction
{
    XDPayMoneyViewController *payViewController = [[XDPayMoneyViewController alloc] initWithNibName:@"XDPayMoneyViewController" bundle:nil];
    [self.navigationController pushViewController:payViewController animated:YES];
    [payViewController release];
}

@end
