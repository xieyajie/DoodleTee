//
//  XDPayMoneyViewController.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

//
//商品信息封装在Product中
//
@interface Product : NSObject{
@private
	float     _price;
	NSString *_subject;
	NSString *_body;
	NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *orderId;

@end


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

@property (nonatomic, strong, setter = setPayMoney:) NSString *payMoney;

- (IBAction)consigneeCheck:(id)sender;

- (IBAction)paymentCheck:(id)sender;

- (IBAction)alipaySelecte:(id)sender;

- (IBAction)creditCardSelect:(id)sender;

@end
