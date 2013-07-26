//
//  XDSettingViewController.m
//  DoodleTee
//
//  Created by xie yajie on 13-6-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "XDSettingViewController.h"

#import "LocalDefault.h"

#define kTagLeftView 0
#define kTagRightView 1

@interface XDSettingViewController ()
{
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    
    NSMutableArray *_selectionArray;
    NSArray *_chimaArray;
    NSArray *_pinpaiArray;
    NSArray *_caizhiArray;
    NSArray *_yanseArray;
}

@end

@implementation XDSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializationi]
        
        _selectionArray = [NSMutableArray arrayWithObjects:
                          [NSIndexPath indexPathForRow:0 inSection:0],
                          [NSIndexPath indexPathForRow:0 inSection:1],
                          [NSIndexPath indexPathForRow:0 inSection:2],
                          [NSIndexPath indexPathForRow:0 inSection:0],
                          nil];
        
        _chimaArray = [NSArray arrayWithObjects:
                        @"XS", @"S", @"M", @"L", @"XL", @"XXL", nil];
        
        _pinpaiArray = [NSArray arrayWithObjects:
                         @"C.K.", @"Jack Jones", @"Armani", @"凡客诚品", nil];
        
        _caizhiArray = [NSArray arrayWithObjects:
                         @"纯棉", @"亚麻", nil];
        
        _yanseArray = [NSArray arrayWithObjects:
                        @"白色", @"黑色", @"灰色", @"绿色", @"红色", @"蓝色", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_overButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    _mainView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
    
    _bottomImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomImageView.layer.shadowOpacity = 1.0;
    _bottomImageView.layer.shadowRadius = 10.0;
    _bottomImageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat height = size.height - _mainView.frame.origin.x - 70;
    
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _mainView.frame.size.width / 2 - 1, height) style:UITableViewStylePlain];
    _leftTableView.tag = kTagLeftView;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.allowsMultipleSelection = YES;
    _leftTableView.separatorColor = [UIColor grayColor];
//    _leftTableView.tableFooterView = [[[UIView alloc] init] autorelease];
    _leftTableView.backgroundColor = [UIColor clearColor];
    [_mainView addSubview:_leftTableView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(_mainView.frame.size.width / 2 - 1, 0, 1, height)];
    line.backgroundColor = [UIColor grayColor];
    [_mainView addSubview:line];

    for (int i = 0; i < _selectionArray.count; i++)
    {
        [_leftTableView selectRowAtIndexPath: [_selectionArray objectAtIndex: i] animated: NO scrollPosition: UITableViewScrollPositionNone];
    }
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(_mainView.frame.size.width / 2, 0, _mainView.frame.size.width / 2, height) style:UITableViewStylePlain];
    _rightTableView.tag = kTagRightView;
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.separatorColor = [UIColor grayColor];
//    _rightTableView.tableFooterView = [[[UIView alloc] init] autorelease];
    _rightTableView.backgroundColor = [UIColor clearColor];
    [_mainView addSubview: _rightTableView];
    
    [_rightTableView selectRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0] animated: NO scrollPosition: UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, _leftTableView.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(20, 0, 50, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    [headerView addSubview: label];
    
    switch (tableView.tag)
    {
        case kTagLeftView:
        {
            switch (section)
            {
                case 0:
                {
                    label.text = @"品牌";
                }break;
                
                case 1:
                {
                    label.text = @"材质";
                }break;
                    
                case 2:
                {
                    label.text = @"颜色";
                }break;
                    
                default:
                    break;
            }
        }break;
            
        case kTagRightView:
        {
            label.text = @"尺码";
        }break;
            
        default:
            break;
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (kTagLeftView == tableView.tag)
    {
        NSIndexPath *oldIndexPath = [_selectionArray objectAtIndex: indexPath.section];
        if (oldIndexPath.section == indexPath.section && oldIndexPath.row != indexPath.row) {
            [tableView deselectRowAtIndexPath: [_selectionArray objectAtIndex: indexPath.section] animated: YES];
            [_selectionArray replaceObjectAtIndex: indexPath.section withObject: indexPath];
        }
    }
    if (kTagRightView == tableView.tag) {
        NSIndexPath *oldIndexPath = [_selectionArray objectAtIndex: 3];
        if (oldIndexPath.section == indexPath.section && oldIndexPath.row != indexPath.row) {
            [tableView deselectRowAtIndexPath: [_selectionArray objectAtIndex: 3] animated: YES];
            [_selectionArray replaceObjectAtIndex: 3 withObject: indexPath];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == kTagLeftView) {
        return 3;
    }
    else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (kTagLeftView == tableView.tag)
    {
        switch (section)
        {
            case 0:
            {
                return [_pinpaiArray count];
            }break;
                
            case 1:
            {
                return [_caizhiArray count];
            }break;
                
            case 2:
            {
                return [_yanseArray count];
            }break;
                
            default:
                return 0;
                break;
        }
    }
    else
    {
        return [_chimaArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SCellIdentifier = @"SCell";
    static NSString *PCellIdentifier = @"PCell";
    static NSString *PSCellIdentifier = @"PSCell";
    NSString *cellIdentifier = nil;
    if (kTagLeftView == tableView.tag)
    {
        if (0 == indexPath.section)
        {
            cellIdentifier = PCellIdentifier;
        }
        else
        {
            cellIdentifier = PSCellIdentifier;
        }
    }
    else
    {
        cellIdentifier = SCellIdentifier;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                               reuseIdentifier: cellIdentifier];
//        cell.contentView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent: 0.1f];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        UIView *selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"setting_cellSelectBackground"]];
        cell.selectedBackgroundView = selectedBackgroundView;
        
        if (PCellIdentifier == cellIdentifier)
        {
//            cell.contentView.backgroundColor = [UIColor redColor];
        }
        else if (PSCellIdentifier == cellIdentifier)
        {
            cell.imageView.image = [UIImage imageNamed: @"setting_unchoiceBox.png"];
        }
    }

    if (kTagLeftView == tableView.tag)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                cell.textLabel.text = [_pinpaiArray objectAtIndex: indexPath.row];
            }break;
            
            case 1:
            {
                cell.textLabel.text = [_caizhiArray objectAtIndex: indexPath.row];
            }break;
                
            case 2:
            {
                cell.textLabel.text = [_yanseArray objectAtIndex: indexPath.row];
            }break;
                
            default:
                cell.textLabel.text = @"String";
                break;
        }
    }
    else
    {
        cell.textLabel.text = [_chimaArray objectAtIndex: indexPath.row];
    }
    
    return cell;
}

#pragma mark - other

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)overAction:(id)sender
{
    //存储数据
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent: KSETTINGPLIST];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath: plistPath])
    {
        [fileManage createFileAtPath: plistPath contents: nil attributes: nil];
    }
    
    NSMutableDictionary *settingDic = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    if (settingDic == nil)
    {
        settingDic = [[NSMutableDictionary alloc] init];
    }
    
    [settingDic setObject: [_pinpaiArray objectAtIndex:[[_selectionArray objectAtIndex:0] row]] forKey: kSETTINGBRAND];
    [settingDic setObject: [_caizhiArray objectAtIndex:[[_selectionArray objectAtIndex:1] row]] forKey: kSETTINGMATERIAL];
    [settingDic setObject: [_yanseArray objectAtIndex:[[_selectionArray objectAtIndex:2] row]] forKey: kSETTINGCOLOR];
    [settingDic setObject: [_chimaArray objectAtIndex:[[_selectionArray objectAtIndex:3] row]] forKey: kSETTINGSIZE];
    
    [settingDic writeToFile: plistPath atomically: YES];
    
    [self backAction:sender];
}

@end
