//
//  XDMessageViewController.m
//  DoodleTee
//
//  Created by Dai Ryan on 13-9-16.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDMessageViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface XDMessageViewController ()

@property (nonatomic, weak) IBOutlet UIView *topView;

@end

@implementation XDMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    self.topView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.topView.layer.shadowOpacity = 0.6f;
    self.topView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
