//
//  XDSettingViewController.m
//  DoodleTee
//
//  Created by xie yajie on 13-6-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "XDSettingViewController.h"
#import "AKSegmentedControl.h"

#import "LocalDefault.h"

#define kTagLeftView 0
#define kTagRightView 1

@interface XDSettingViewController ()<AKSegmentedControlDelegate>
{
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    
    NSArray *_dataSource;
    NSMutableArray *_selectionArray;
}

@end

@implementation XDSettingViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initializationi
        _dataSource = [NSArray array];
        _selectionArray = [NSMutableArray arrayWithObjects:[NSMutableDictionary dictionary], [NSMutableDictionary dictionary], nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getSettingSource];
    [self configurationSettingSelected];
    
    [self layoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(20, 0, 50, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    [headerView addSubview: label];
    
    NSInteger tag = tableView.tag == kTagLeftView ? 0 : 1;
    label.text = [[[_dataSource objectAtIndex:tag] objectAtIndex:section] objectForKey:@"title"];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag = tableView.tag == kTagLeftView ? 0 : 1;
    NSString *key = [[[_dataSource objectAtIndex:tag] objectAtIndex:indexPath.section] objectForKey:@"title"];
    
    NSIndexPath *oldIndex = [[_selectionArray objectAtIndex:tag] objectForKey:key];
    if (oldIndex.section == indexPath.section && oldIndex.row != indexPath.row)
    {
        [tableView deselectRowAtIndexPath:oldIndex animated:YES];
    }
    [[_selectionArray objectAtIndex:tag] setObject:indexPath forKey:key];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger tag = tableView.tag == kTagLeftView ? 0 : 1;
    return [[_dataSource objectAtIndex:tag] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tag = tableView.tag == kTagLeftView ? 0 : 1;
    return [[[[_dataSource objectAtIndex:tag] objectAtIndex:section] objectForKey:@"source"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    static NSString *CheckCellIdentifier = @"CheckCellIdentifier";
    NSString *cellIdentifier = nil;
    if (0 == indexPath.section)
    {
        cellIdentifier = CellIdentifier;
    }
    else
    {
        cellIdentifier = CheckCellIdentifier;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        UIView *selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"setting_cellSelectBackground"]];
        cell.selectedBackgroundView = selectedBackgroundView;
        
        if (CellIdentifier == cellIdentifier)
        {
            cell.imageView.image = nil;
        }
        else if (CheckCellIdentifier == cellIdentifier)
        {
            cell.imageView.image = [UIImage imageNamed: @"setting_unchoiceBox.png"];
        }
    }
    
    NSInteger tag = tableView.tag == kTagLeftView ? 0 : 1;
    NSMutableDictionary *dic = [[_dataSource objectAtIndex:tag] objectAtIndex:indexPath.section];
    NSString *title = [dic objectForKey:@"title"];
    NSString *text = [[dic objectForKey:@"source"] objectAtIndex:indexPath.row];
    NSIndexPath *tmpIndex = [[_selectionArray objectAtIndex:tag] objectForKey:title];
    cell.textLabel.text = text;
    if (tmpIndex.section == indexPath.section && tmpIndex.row == indexPath.row) {
//        cell.selected = YES;
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else{
//        cell.selected = NO;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

    return cell;
}

#pragma mark - AKSegmentedControl Delegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            [self backAction:nil];
            break;
        case 1:
            [self overAction:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - layout subviews

- (void)layoutSubviews
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.image = [UIImage imageNamed:@"root_bg.png"];
    [self.view addSubview:bgView];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, self.view.frame.size.height - 10 - 62.5)];
    _mainView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
    [self.view addSubview:_mainView];
    
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _mainView.frame.size.width / 2 - 1, _mainView.frame.size.height) style:UITableViewStylePlain];
    _leftTableView.tag = kTagLeftView;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.allowsMultipleSelection = YES;
    _leftTableView.separatorColor = [UIColor grayColor];
    _leftTableView.backgroundColor = [UIColor clearColor];
    [_mainView addSubview:_leftTableView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(_mainView.frame.size.width / 2 - 1, 0, 1, _mainView.frame.size.height)];
    line.backgroundColor = [UIColor grayColor];
    [_mainView addSubview:line];
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(_mainView.frame.size.width / 2, 0, _mainView.frame.size.width / 2, _mainView.frame.size.height) style:UITableViewStylePlain];
    _rightTableView.tag = kTagRightView;
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.separatorColor = [UIColor grayColor];
    _rightTableView.backgroundColor = [UIColor clearColor];
    [_mainView addSubview: _rightTableView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 62.5, self.view.frame.size.width, 62.5)];
    UIImageView *bottomImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomBarBg.png"]];
    bottomImgView.frame = CGRectMake(0, 0, _bottomView.frame.size.width, _bottomView.frame.size.height);
    [_bottomView addSubview:bottomImgView];
    [self.view addSubview:_bottomView];
    _bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomView.layer.shadowOpacity = 1.0;
    _bottomView.layer.shadowRadius = 10.0;
    _bottomView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.view addSubview:_bottomView];
    
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
    
    //完成
    UIButton *buttonDone = [[UIButton alloc] initWithFrame:CGRectMake(buttonBack.frame.origin.x + buttonBack.frame.size.width, 0, width, segmentedControl.frame.size.height)];
    buttonDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    buttonDone.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonDone setTitle:@"选择结束" forState:UIControlStateNormal];
    [buttonDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonDone.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonDone setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonDone setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [segmentedControl setButtonsArray:@[buttonBack, buttonDone]];
}

- (void)getSettingSource
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"settingSource" ofType:@"plist"];
    _dataSource = [[NSArray alloc] initWithContentsOfFile:filePath];
}

- (void)configurationSettingSelected
{
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent: KSETTINGPLIST];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath: plistPath])
    {
        [fileManage createFileAtPath: plistPath contents: nil attributes: nil];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile: plistPath];
    if (array == nil || [array count] == 0) {
        _selectionArray = [NSMutableArray arrayWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSIndexPath indexPathForRow:0 inSection:0], kSETTINGBRAND, [NSIndexPath indexPathForRow:0 inSection:1], kSETTINGMATERIAL, [NSIndexPath indexPathForRow:0 inSection:2], kSETTINGCOLOR, nil], [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSIndexPath indexPathForRow:0 inSection:0], kSETTINGSIZE, nil], nil];
    }
    else{
        NSMutableDictionary *dic1 = [array objectAtIndex:0];
        for (int i = 0; i < [[_dataSource objectAtIndex:0] count]; i++) {
            NSMutableDictionary *item = [[_dataSource objectAtIndex:0] objectAtIndex:i];
            NSString *key = [item objectForKey:@"title"];
            NSString *set1 = [dic1 objectForKey:key];
            for (int j = 0; j < [[item objectForKey:@"source"] count]; j++) {
                NSString *str = [[item objectForKey:@"source"] objectAtIndex:j];
                if ([str isEqualToString:set1]) {
                    [[_selectionArray objectAtIndex:0] setObject:[NSIndexPath indexPathForRow:j inSection:i] forKey:key];
                    break;
                }
            }
        }
        
        NSMutableDictionary *dic2 = [array objectAtIndex:1];
        for (int k = 0; k < [[_dataSource objectAtIndex:1] count]; k++) {
            NSMutableDictionary *item = [[_dataSource objectAtIndex:1] objectAtIndex:k];
            NSString *key = [item objectForKey:@"title"];
            NSString *set1 = [dic2 objectForKey:key];
            for (int g = 0; g < [[item objectForKey:@"source"] count]; g++) {
                NSString *str = [[item objectForKey:@"source"] objectAtIndex:g];
                if ([str isEqualToString:set1]) {
                    [[_selectionArray objectAtIndex:1] setObject:[NSIndexPath indexPathForRow:g inSection:k] forKey:key];
                    break;
                }
            }
        }
    }
}

#pragma mark - other

- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)overAction:(id)sender
{
    //存储数据
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent: KSETTINGPLIST];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath: plistPath])
    {
        [fileManage createFileAtPath: plistPath contents: nil attributes: nil];
    }
    
    NSMutableArray *settings = [[NSMutableArray alloc] initWithContentsOfFile: plistPath];
    if (settings == nil)
    {
        settings = [[NSMutableArray alloc] init];
    }
    
    [settings removeAllObjects];
    for (int i = 0; i < [_selectionArray count]; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableDictionary *sdic = [_selectionArray objectAtIndex:i];
        NSMutableArray *data = [_dataSource objectAtIndex:i];
        for (int j = 0; j < [sdic count]; j++) {
            NSMutableDictionary *item = [data objectAtIndex:j];
            NSString *key = [item objectForKey:@"title"];
            NSInteger row = [[sdic objectForKey:key] row];
            [dic setObject:[[item objectForKey:@"source"] objectAtIndex:row] forKey:key];
        }
        
        [settings addObject:dic];
    }
    
    [settings writeToFile: plistPath atomically: YES];
    
    [self backAction:sender];
}

@end
