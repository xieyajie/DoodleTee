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
        
        CGRect bounds = [[UIScreen mainScreen] bounds];
        if (_version >= 7.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            _mainRect = CGRectMake(0, 20, bounds.size.width, bounds.size.height);
        }
        else{
            _mainRect = CGRectMake(0, 0, bounds.size.width, bounds.size.height - 20);
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(_mainRect.origin.x, _mainRect.origin.y, _mainRect.size.width, _mainRect.size.height)];
    _backgroundView.image = [UIImage imageNamed:@"root_bg.png"];
    [self.view addSubview:_backgroundView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
