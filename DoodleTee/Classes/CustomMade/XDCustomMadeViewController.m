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

#define kUnitPrice 20

@interface XDCustomMadeViewController ()<AKSegmentedControlDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary *_attributeDic;
    NSArray *_titleArray;
    UIImage *_clothImage;
    
    UITextField *_countField;
    UILabel *_moneyLabel;
    UIButton *_subButton;
}

@property (nonatomic, strong) NSMutableDictionary *attributeDic;

@end

@implementation XDCustomMadeViewController

@synthesize titleLabel = _titleLabel;

@synthesize tableView = _tableView;

@synthesize bottomView = _bottomView;

@synthesize attributeDic = _attributeDic;

- (id)initWithClothImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        // Custom initialization
        _countField = [[UITextField alloc] init];
        _countField.textAlignment = KTextAlignmentCenter;
        _countField.borderStyle = UITextBorderStyleRoundedRect;
        _countField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _countField.text = @"1";
        _countField.userInteractionEnabled = NO;
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        _moneyLabel.text = @"20 元";
        
        _titleArray = [[NSArray alloc] initWithObjects:kSETTINGBRAND, kSETTINGMATERIAL, kSETTINGSIZE, kSETTINGCOLOR, nil];
        _attributeDic = [NSMutableDictionary dictionary];
        
        _clothImage = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configurationAttribute];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.image = [UIImage imageNamed:@"root_bg.png"];
    [self.view addSubview:bgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewX, kTitleY, kViewWidth, kTitleHeight)];
    _titleLabel.textAlignment = KTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0];
    _titleLabel.text = @"定制我设计的T恤";
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
    _bottomView.layer.shadowRadius = 10.0;
    _bottomView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.view bringSubviewToFront:_bottomView];
}

- (void)loadView
{
    [super loadView];
    
    NSLog(@"%@", _tableView);
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
        XDAttributeCell *cell = (XDAttributeCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        
        if (nil == cell)
        {
            cell = [[XDAttributeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        NSString *str = [_titleArray objectAtIndex:(indexPath.row - 1)];
        cell.title = [NSString stringWithFormat:@"%@：", str];
        cell.value = [_attributeDic objectForKey:str];
        
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
    NSMutableArray *settings = [[NSMutableArray alloc] initWithContentsOfFile: plistPath];
    for (NSMutableDictionary *dic in settings) {
        [self.attributeDic setValuesForKeysWithDictionary:dic];
    }
}

- (UITableViewCell *)configurationImageCell
{
    static NSString *ImageCellIdentifier = @"ImageCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier: ImageCellIdentifier];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageCellIdentifier];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, self.tableView.frame.size.width, 200)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = _clothImage;
        [cell.contentView addSubview:imageView];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)configurationCountCell
{
    static NSString *CountCellIdentifier = @"CountCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier: CountCellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CountCellIdentifier];
        
        CGFloat height = cell.contentView.frame.size.height;
        
        UILabel *attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 70, height)];
        attributeLabel.backgroundColor = [UIColor clearColor];
        attributeLabel.font = [UIFont boldSystemFontOfSize:20];
        [cell.contentView addSubview:attributeLabel];
        attributeLabel.text = @"数量：";
        
        _subButton = [[UIButton alloc] initWithFrame:CGRectMake(attributeLabel.frame.origin.x + attributeLabel.frame.size.width, 0, 30, height)];
        [_subButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        [_subButton addTarget:self action:@selector(subCount:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_subButton];
        _subButton.enabled = NO;
        
        _countField.frame = CGRectMake(_subButton.frame.origin.x + _subButton.frame.size.width + 10, (height - 30) / 2, 50, 30);
        [cell.contentView addSubview:_countField];
        
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(_countField.frame.origin.x + _countField.frame.size.width + 10, 0, 30, height)];
        [addButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addCount:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addButton];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)configurationMoneyCell
{
    static NSString *MoneyCellIdentifier = @"MoneyCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier: MoneyCellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MoneyCellIdentifier];
        
        UILabel *attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 70, cell.contentView.frame.size.height)];
        attributeLabel.backgroundColor = [UIColor clearColor];
        attributeLabel.font = [UIFont boldSystemFontOfSize:20];
        [cell.contentView addSubview:attributeLabel];
        attributeLabel.text = @"总价：";
        
        _moneyLabel.frame = CGRectMake(attributeLabel.frame.origin.x + attributeLabel.frame.size.width, 0, 200, cell.contentView.frame.size.height);
        [cell.contentView addSubview:_moneyLabel];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 

- (void)subCount:(id)sender
{
    NSInteger count = [_countField.text integerValue];
    count - 1 > 0 ? count-- : 1;
    if (count == 1) {
        _subButton.enabled = NO;
    }
    else{
        _subButton.enabled = YES;
    }
    _countField.text = [NSString stringWithFormat:@"%i", count];
    _moneyLabel.text = [NSString stringWithFormat:@"%i 元", (count * kUnitPrice)];
}

- (void)addCount:(id)sender
{
    _subButton.enabled = YES;
    
    NSInteger count = [_countField.text integerValue];
    _countField.text = [NSString stringWithFormat:@"%i", ++count];
    _moneyLabel.text = [NSString stringWithFormat:@"%i 元", (count * kUnitPrice)];
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
    buttonBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBack.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonBack setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    
    //提交订单
    UIButton *buttonDone = [[UIButton alloc] initWithFrame:CGRectMake(buttonBack.frame.origin.x + buttonBack.frame.size.width, 0, width, segmentedControl.frame.size.height)];
    buttonDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [buttonDone setTitle:@"提交订单" forState:UIControlStateNormal];
    [buttonDone.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonDone setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    
    [segmentedControl setButtonsArray:@[buttonBack, buttonDone]];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneAction
{
    XDPayMoneyViewController *payViewController = [[XDPayMoneyViewController alloc] initWithNibName:@"XDPayMoneyViewController" bundle:nil];
    payViewController.payMoney = _moneyLabel.text;
    [self.navigationController pushViewController:payViewController animated:YES];
}

@end
