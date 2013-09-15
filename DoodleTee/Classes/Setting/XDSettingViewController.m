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

#import "XDShareMethods.h"
#import "LocalDefault.h"

#define kTagLeftView 0
#define kTagRightView 1

@interface XDSettingViewController ()<AKSegmentedControlDelegate>
{
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    
    NSMutableDictionary *_dataSource;
    NSDictionary *_imageSource;
    NSDictionary *_colorSource;
    NSMutableDictionary *_selectionDictionary;
    NSMutableDictionary *_selectionindexPaths;
}

@end

@implementation XDSettingViewController

@synthesize currentClotheImageName = _currentClotheImageName;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initializationi
        _dataSource = [NSMutableDictionary dictionary];
        _imageSource = [NSDictionary dictionary];
        _colorSource = [NSDictionary dictionary];
        _selectionDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableDictionary dictionary], kSettingLeftView, [NSMutableDictionary dictionary], kSettingRightView, nil];
        _selectionindexPaths = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableDictionary dictionary], kSettingLeftView, [NSMutableDictionary dictionary], kSettingRightView, nil];
        
        _currentClotheImageName = nil;
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
    
    NSString *key = tableView.tag == kTagLeftView ? kSettingLeftView : kSettingRightView;
    label.text = [[[_dataSource objectForKey:key] objectAtIndex:section] objectForKey:kSettingDataTitle];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = tableView.tag == kTagLeftView ? kSettingLeftView : kSettingRightView;
    NSMutableDictionary *dic = [[_dataSource objectForKey:key] objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:kSettingDataSource];
    NSString *title = [dic objectForKey:kSettingDataTitle];
    
    NSIndexPath *oldIndex = [[_selectionindexPaths objectForKey:key] objectForKey:title];
    if (oldIndex.section == indexPath.section && oldIndex.row != indexPath.row)
    {
        [tableView deselectRowAtIndexPath:oldIndex animated:YES];
        
        [[_selectionDictionary objectForKey:key] setObject:[array objectAtIndex:indexPath.row] forKey:title];
        [[_selectionindexPaths objectForKey:key] setObject:indexPath forKey:title];
    }
    
    if ([title isEqualToString:kSETTINGMATERIAL]) {
        NSString *oldTitle = [[[[_dataSource objectForKey:key] objectAtIndex:oldIndex.section] objectForKey:kSettingDataSource] objectAtIndex:oldIndex.row];
        if (![oldTitle isEqualToString:title]) {
            NSInteger colorSection = [[[_selectionindexPaths objectForKey:key] objectForKey:kSETTINGCOLOR] section];
            NSMutableDictionary *colorDic = [[_dataSource objectForKey:key] objectAtIndex:colorSection];
            [colorDic setObject:[_colorSource objectForKey:[array objectAtIndex:indexPath.row]] forKey:kSettingDataSource];
            
//            [_leftTableView reloadData];
            
            [[_selectionDictionary objectForKey:key] setObject:[[colorDic objectForKey:kSettingDataSource] objectAtIndex:0] forKey:kSETTINGCOLOR];
            [[_selectionindexPaths objectForKey:key] setObject:[NSIndexPath indexPathForRow:0 inSection:colorSection] forKey:kSETTINGCOLOR];
            
            [_leftTableView beginUpdates];
            [_leftTableView reloadSections:[NSIndexSet indexSetWithIndex:colorSection] withRowAnimation:UITableViewRowAnimationNone];
            [_leftTableView endUpdates];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSString *key = tableView.tag == kTagLeftView ? kSettingLeftView : kSettingRightView;
    return [[_dataSource objectForKey:key] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = tableView.tag == kTagLeftView ? kSettingLeftView : kSettingRightView;
    return [[[[_dataSource objectForKey:key] objectAtIndex:section] objectForKey:kSettingDataSource] count];
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
    }
    
    NSString *key = tableView.tag == kTagLeftView ? kSettingLeftView : kSettingRightView;
    NSMutableDictionary *dic = [[_dataSource objectForKey:key] objectAtIndex:indexPath.section];
    NSString *title = [dic objectForKey:kSettingDataTitle];
    NSString *text = [[dic objectForKey:kSettingDataSource] objectAtIndex:indexPath.row];
    
    if ([CellIdentifier isEqualToString:cellIdentifier])
    {
        cell.imageView.image = nil;
    }
    else if ([CheckCellIdentifier isEqualToString:cellIdentifier])
    {
        NSDictionary *imageDic = [_imageSource objectForKey:text];
        cell.imageView.image = [UIImage imageNamed: [imageDic objectForKey:kSettingImageIcon]];
    }
    
    NSIndexPath *setIndex = [[_selectionindexPaths objectForKey:key] objectForKey:title];
    cell.textLabel.text = text;
    if (setIndex.section == indexPath.section && setIndex.row == indexPath.row) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else{
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
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    _dataSource = [dataDic objectForKey:kSettingSourceData];
    _imageSource = [dataDic objectForKey:kSettingSourceImage];
    _colorSource = [dataDic objectForKey:kSettingSourceColor];
}

- (void)configurationSettingSelected
{
    NSString *key = nil;
    //判断是否登录
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
    //未登录
    if (userName == nil || userName.length == 0) {
        key = kUserDefault;
    }
    else{
        key = userName;
    }
    
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent: KSETTINGPLIST];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath: plistPath])
    {
        [fileManage createFileAtPath: plistPath contents: nil attributes: nil];
    }
    
    NSMutableDictionary *dictionary = nil;
    NSMutableDictionary *setDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (setDic == nil) {
        setDic = [NSMutableDictionary dictionary];
    }
    else{
        dictionary = [setDic objectForKey:key];
    }
    
    NSString *color = nil;
    if (_currentClotheImageName != nil && _currentClotheImageName.length > 0) {
        for (NSString *colorKey in _imageSource) {
            NSDictionary *imageDic = [_imageSource objectForKey:colorKey];
            if ([_currentClotheImageName isEqualToString:[imageDic objectForKey:kSettingImageClothe]]) {
                color = colorKey;
                break;
            }
        }
    }
    
    NSInteger section = 0;
    if (dictionary == nil || [dictionary count] == 0) {
        _selectionDictionary = [NSMutableDictionary dictionary];
        _selectionindexPaths = [NSMutableDictionary dictionary];
        
        for (NSString *dataKey in _dataSource) {
            NSArray *dataArray = [_dataSource objectForKey:dataKey];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSMutableDictionary *indexDic = [NSMutableDictionary dictionary];
            
            for (NSDictionary *dataDic in dataArray) {
                NSInteger row = 0;
                NSString *key = [dataDic objectForKey:kSettingDataTitle];
                NSString *info = [[dataDic objectForKey:kSettingDataSource] objectAtIndex:row];
                
                if (color != nil && [key isEqualToString:kSETTINGCOLOR]) {
                    if (![color isEqualToString:info]) {
                        info = color;
                    }
                    
                    NSInteger row = [[dataDic objectForKey:kSettingDataSource] indexOfObject:info];
                    if (row < 0) {
                        row = 0;
                    }
                }
                
                [dic setObject:info forKey:key];
                [indexDic setObject:[NSIndexPath indexPathForRow:row inSection:section] forKey:key];
                section++;
            }
            [_selectionDictionary setObject:dic forKey:dataKey];
            [_selectionindexPaths setObject:indexDic forKey:dataKey];
            section = 0;
        }
    }
    else{
        NSString *tmpColorkey = nil;
        
        for (NSString *dataKey in _dataSource) {
            NSMutableArray *dataArray = [_dataSource objectForKey:dataKey];
            for (NSMutableDictionary *dic in dataArray) {
                NSString *key = [dic objectForKey:kSettingDataTitle];
                NSString *setInfo = [dictionary objectForKey:key];
                
                if ([key isEqualToString:kSETTINGMATERIAL]) {
                    tmpColorkey = setInfo;
                }
                
                if (color != nil && [key isEqualToString:kSETTINGCOLOR]) {
                    if (tmpColorkey != nil && [tmpColorkey length] > 0) {
                        [dic setObject:[_colorSource objectForKey:tmpColorkey] forKey:kSettingDataSource];
                    }
                    
                    if (color != nil && ![color isEqualToString:setInfo]) {
                        setInfo = color;
                    }
                }
                [[_selectionDictionary objectForKey:dataKey] setObject:setInfo forKey:key];
                
                NSInteger row = [[dic objectForKey:kSettingDataSource] indexOfObject:setInfo];
                if (row < 0) {
                    row = 0;
                }
                [[_selectionindexPaths objectForKey:dataKey] setObject:[NSIndexPath indexPathForRow:row inSection:section] forKey:key];
                section++;
            }
            section = 0;
        }
    }
}

#pragma mark - other

- (void)backAction:(id)sender
{
    [XDShareMethods dismissViewController:self animated:YES completion:nil];
}

- (void)overAction:(id)sender
{
    NSString *key = nil;
    //判断是否登录
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
    //未登录
    if (userName == nil || userName.length == 0) {
        key = kUserDefault;
    }
    else{
        key = userName;
    }
    
    //存储数据
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent: KSETTINGPLIST];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath: plistPath])
    {
        [fileManage createFileAtPath: plistPath contents: nil attributes: nil];
    }
    NSMutableDictionary *setDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (setDic == nil) {
        setDic = [NSMutableDictionary dictionary];
    }
    
    NSMutableDictionary *settings = [setDic objectForKey:key];
    if (settings == nil)
    {
        settings = [[NSMutableDictionary alloc] init];
    }
    
    NSString *imgName = nil;
    for (NSString *dicKey in _selectionDictionary) {
        NSMutableDictionary *sdic = [_selectionDictionary objectForKey:dicKey];
        for (NSString *sKey in sdic) {
            NSString *sInfo = [sdic objectForKey:sKey];
            [settings setObject:sInfo forKey:sKey];
            
            if ([sKey isEqualToString:kSETTINGCOLOR]) {
                imgName = [[_imageSource objectForKey:sInfo] objectForKey:kSettingImageClothe];
            }
        }
    }
    
    if(imgName == nil || imgName.length == 0)
    {
        imgName = @"clothe_default.png";
    }
    NSString *oldImgName = [settings objectForKey:kSettingImageClothe];
    if (![oldImgName isEqualToString:imgName]) {
        [settings setObject:imgName forKey:kSettingImageClothe];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeClotheImage object:imgName];
    }
        
    [setDic setObject:settings forKey:key];
    [setDic writeToFile: plistPath atomically: YES];
    
    [self backAction:sender];
}

@end
