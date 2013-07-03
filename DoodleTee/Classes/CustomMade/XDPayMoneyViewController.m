//
//  XDPayMoneyViewController.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDPayMoneyViewController.h"

@interface XDPayMoneyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@end

@implementation XDPayMoneyViewController

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
    // Do any additional setup after loading the view from its nib.
    _titleLabel.text = @"付款";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurationBottomView
{
    
}

- (void)configurationMainView:(UIView *)aView
{
    _mainView = [[UITableView alloc] init];
    _mainView.delegate = self;
    _mainView.dataSource = self;
    
    [super configurationMainView];
}

@end
