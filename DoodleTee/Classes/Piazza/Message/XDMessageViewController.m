//
//  XDMessageViewController.m
//  DoodleTee
//
//  Created by Dai Ryan on 13-9-16.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDMessageViewController.h"

#import "LocalDefault.h"

@interface XDMessageViewController ()
{
    UILabel *_topLabel;
}

@end

@implementation XDMessageViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 31)];
    _topLabel.font = [UIFont systemFontOfSize:18];
    _topLabel.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0];
    _topLabel.textAlignment = KTextAlignmentCenter;
    _topLabel.text = @"我的消息";
    _topLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    _topLabel.layer.shadowOpacity = 5.0;
    _topLabel.layer.shadowRadius = 10.0;
    _topLabel.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.view addSubview:_topLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
