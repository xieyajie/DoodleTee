//
//  XDViewController.m
//  XDUI
//
//  Created by xieyajie on 13-10-14.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDViewController.h"

@interface XDViewController ()
{
    CGFloat _version;
}

@end

@implementation XDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _version = [[[UIDevice currentDevice] systemVersion] floatValue];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    _viewX = 0;
    if (_version >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _viewX = 20;
    }
    
    _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _backgroundView.image = [UIImage imageNamed:@"root_bg.png"];
    [self.view addSubview:_backgroundView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
