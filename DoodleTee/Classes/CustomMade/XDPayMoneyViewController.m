//
//  XDPayMoneyViewController.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDPayMoneyViewController.h"

@interface XDPayMoneyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UIView *payMoneyView;

@end

@implementation XDPayMoneyViewController

@synthesize payMoneyView = _payMoneyView;

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
    // Do any additional setup after loading the view from its nib.
    _titleLabel.text = @"付款";
    
    [self configurationMainView:_payMoneyView];
    
    _moneyLabel.backgroundColor = [UIColor clearColor];
    _payerField.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    _consigneeField.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    _telField.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    _addressField.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    
    [_consigneeCheckButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [_consigneeCheckButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateSelected];
    
    [_paymentCheckButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [_paymentCheckButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurationBottomView
{
    
}

- (void)configurationMainView:(UIView *)aView
{
//    _payMoneyView = [[UIView alloc] init];
    [super configurationMainView:self.payMoneyView];
}

#pragma mark - IBAction

- (IBAction)consigneeCheck:(id)sender
{
    _consigneeCheckButton.selected = !_consigneeCheckButton.selected;
}

- (IBAction)paymentCheck:(id)sender
{
    _paymentCheckButton.selected = !_paymentCheckButton;
}

- (IBAction)alipaySelecte:(id)sender
{
    _paymentAlipay.selected = !_paymentAlipay.selected;
    _paymentAlipay.selected ? [_paymentAlipay setBackgroundColor:[UIColor blueColor]] : [_paymentAlipay setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)creditCard:(id)sender
{
    _paymentCreditCard.selected = !_paymentCreditCard.selected;
    _paymentCreditCard.selected ? [_paymentCreditCard setBackgroundColor:[UIColor blueColor]] : [_paymentCreditCard setBackgroundColor:[UIColor clearColor]];
}


@end
