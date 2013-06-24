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
    IBOutlet UIView *_mainView;
    IBOutlet UILabel *_titleLable;
    IBOutlet UIImageView *_bottomImageView;
    
    IBOutlet UITextField *_userNameField;
    IBOutlet UITextField *_pasdField;
    IBOutlet UIButton *_registerButton;
    IBOutlet UIButton *_loginButton;
    IBOutlet UIButton *_backButton;
}

- (IBAction)backAction:(id)sender;

- (IBAction)registerAction:(id)sender;

- (IBAction)loginAction:(id)sender;

@end
