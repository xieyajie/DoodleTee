//
//  XDAccountViewController.m
//  DoodleTee
//
//  Created by xie yajie on 13-5-28.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "XDAccountViewController.h"

#import "LocalDefault.h"

@interface XDAccountViewController ()

@end

@implementation XDAccountViewController

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
	// Do any additional setup after loading the view.
    _mainView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
    
    _bottomImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomImageView.layer.shadowOpacity = 1.0;
    _bottomImageView.layer.shadowRadius = 10.0;
    _bottomImageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    _titleLable.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0];
    _userNameField.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    _pasdField.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (BOOL)checkAccountInfo
{
    if ([_userNameField.text isEqualToString:@""] || [_pasdField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - button action

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)registerAction:(id)sender
{
    if ([self checkAccountInfo]) {
        //
    }
}

- (IBAction)loginAction:(id)sender
{
//    if ([self checkAccountInfo]) {
//        //
//    }
    [self dismissViewControllerAnimated: NO completion: ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLandSuccess object:nil];
    }];
}

@end
