//
//  XDPayMoneyViewController.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPayMoneyViewController : UIViewController
{
    IBOutlet UIView *_payMoneyView;
    
    IBOutlet UILabel *_moneyLabel;
    IBOutlet UITextField *_payerField;
    IBOutlet UITextField *_consigneeField;
    IBOutlet UITextField *_telField;
    IBOutlet UITextField *_addressField;
    IBOutlet UIButton *_consigneeCheckButton;
    
    IBOutlet UIButton *_paymentAlipay;
    IBOutlet UIButton *_paymentCreditCard;
    IBOutlet UIButton *_paymentCheckButton;
    
    UILabel *_titleLabel;
    
    UIView *_bottomView;
}

@property (nonatomic, retain, setter = setPayMoney:) NSString *payMoney;

- (IBAction)consigneeCheck:(id)sender;

- (IBAction)paymentCheck:(id)sender;

- (IBAction)alipaySelecte:(id)sender;

- (IBAction)creditCardSelect:(id)sender;

@end
