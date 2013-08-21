//
//  XDAccountViewController.m
//  DoodleTee
//
//  Created by xie yajie on 13-5-28.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "XDAccountViewController.h"
#import "AKSegmentedControl.h"
#import "MBProgressHUD.h"

#import "XDShareMethods.h"
#import "XDDataCenter.h"
#import "LocalDefault.h"

@interface XDAccountViewController ()

@end

@implementation XDAccountViewController

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
	// Do any additional setup after loading the view.
    [self layoutSubviews];
     
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeybord:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)hideKeybord:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [_userNameField resignFirstResponder];
        [_pasdField resignFirstResponder];
    }
}

#pragma mark - private

- (void)layoutSubviews
{
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bgView.image = [UIImage imageNamed:@"root_bg.png"];
    [self.view addSubview:_bgView];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, self.view.frame.size.height - 10)];
    _mainView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
    [self.view addSubview:_mainView];
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _mainView.frame.size.width, 31)];
    _titleLable.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0];
    _titleLable.text = @"账户";
    _titleLable.textAlignment = KTextAlignmentCenter;
    [_mainView addSubview:_titleLable];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 70, 68, 20)];
    _nameLabel.text = @"用户名：";
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_mainView addSubview:_nameLabel];
    
    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(80, 65, 181, 30)];
    _userNameField.borderStyle = UITextBorderStyleNone;
    _userNameField.placeholder = @"用户名";
    _userNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userNameField.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    [_mainView addSubview:_userNameField];
    
    _pswdLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 130, 68, 20)];
    _pswdLabel.text = @"密码：";
    _pswdLabel.backgroundColor = [UIColor clearColor];
    [_mainView addSubview:_pswdLabel];
    
    _pasdField = [[UITextField alloc] initWithFrame:CGRectMake(80, 125, 181, 30)];
    _pasdField.borderStyle = UITextBorderStyleNone;
    _pasdField.placeholder = @"密码";
    _pasdField.secureTextEntry = YES;
    _pasdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pasdField.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    [_mainView addSubview:_pasdField];
    
    _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 180, 60, 30)];
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"buttonBg.png"] forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_registerButton];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(192, 180, 60, 30)];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"buttonBg.png"] forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_loginButton];
    
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
    
    // 返回
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(12, 10, _bottomView.frame.size.width - 12 - 11, 42)];
    buttonBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    buttonBack.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBack.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonBack setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"functionBarBg.png"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:buttonBack];
}

- (BOOL)checkAccountInfo
{
    UIAlertView *alertView = nil;
    if (_userNameField.text.length <= 0) {
        alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];        
        return NO;
    }
    else if (_pasdField.text.length < 6)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"密码不能小于6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

#pragma mark - button action

- (void)backAction:(id)sender
{
    [XDShareMethods dismissViewController:self animated:YES completion:nil];
//    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)registerAction:(id)sender
{
    if ([self checkAccountInfo]) {
        [_userNameField resignFirstResponder];
        [_pasdField resignFirstResponder];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[XDDataCenter sharedCenter] registerWithUserName:_userNameField.text password:_pasdField.text realName:nil tel:nil address:nil complete:^(id result){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                NSInteger code = [result objectForKey:kREQUESTRESULTCODE];
                if (code > 0)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:_userNameField.text forKey:kUserDefaultsUserName];
                    [XDShareMethods dismissViewController:self animated:YES completion:nil];
                }
                else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"注册失败，请重新操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }onError:^(NSError *error){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"注册失败，请重新操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }];
    }
}

- (void)loginAction:(id)sender
{
    if ([self checkAccountInfo]) {
        [_userNameField resignFirstResponder];
        [_pasdField resignFirstResponder];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __block NSString *userName = _userNameField.text;
        [[XDDataCenter sharedCenter] loginWithUserName:_userNameField.text password:_pasdField.text complete:^(id result){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                NSInteger code = [result objectForKey:kREQUESTRESULTCODE];
                if (code > 0) {
                    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserDefaultsUserName];
                    [XDShareMethods dismissViewController:self animated:YES completion:nil];
                }
                else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"登录失败，请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }onError:^(NSError *error){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"登录失败，请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }];
    }
    
//    [self dismissViewControllerAnimated: NO completion: ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLandSuccess object:nil];
//    }];
}

@end
