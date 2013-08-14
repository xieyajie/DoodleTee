//
//  XDAccountViewController.h
//  DoodleTee
//
//  Created by xie yajie on 13-5-28.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDAccountViewController : UIViewController<UITextFieldDelegate>
{
    UIImageView *_bgView;
    UIView *_mainView;
    UIView *_bottomView;
    
    UILabel *_titleLable;
    UILabel *_nameLabel;
    UILabel *_pswdLabel;
    UITextField *_userNameField;
    UITextField *_pasdField;
    UIButton *_registerButton;
    UIButton *_loginButton;
    UIButton *_backButton;
}

- (void)backAction:(id)sender;

- (void)registerAction:(id)sender;

- (void)loginAction:(id)sender;

@end
