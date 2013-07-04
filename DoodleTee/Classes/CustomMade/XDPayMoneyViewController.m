//
//  XDPayMoneyViewController.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "XDPayMoneyViewController.h"

#import "AKSegmentedControl.h"

#import "LocalDefault.h"

@interface XDPayMoneyViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AKSegmentedControlDelegate>

@property (nonatomic, retain) UIView *payMoneyView;

@end

@implementation XDPayMoneyViewController

@synthesize payMoneyView = _payMoneyView;

@synthesize payMoney = _payMoney;

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
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewX, kTitleY, kViewWidth, kTitleHeight)];
    _titleLabel.textAlignment = KTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0];
    _titleLabel.text = @"付款";
    [self.view addSubview:_titleLabel];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kBottomHeight, self.view.frame.size.width, kBottomHeight)];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _bottomView.frame.size.width, kBottomHeight)];
    bg.contentMode = UIViewContentModeScaleAspectFit;
    bg.image = [UIImage imageNamed:@"bottomBarBg.png"];
    [_bottomView addSubview:bg];
    [bg release];
    [self configurationBottomView];
    [self.view addSubview:_bottomView];
    
    [self configurationMainView:_payMoneyView];
    
    _moneyLabel.backgroundColor = [UIColor clearColor];
    _moneyLabel.text = self.payMoney;
    
    _payerField.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    _consigneeField.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    _telField.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    _telField.keyboardType = UIKeyboardTypeNumberPad;
    _addressField.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    
    [_consigneeCheckButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [_consigneeCheckButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateSelected];
    
    [_paymentCheckButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [_paymentCheckButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateSelected];
    
    [_paymentCreditCard setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_paymentCreditCard setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_paymentAlipay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_paymentAlipay setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    _bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomView.layer.shadowOpacity = 1.0;
    _bottomView.layer.shadowRadius = 8.0;
    _bottomView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.view bringSubviewToFront:_bottomView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tap];
    [tap release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - AKSegmentedControl delegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            [self backAction];
            break;
        case 1:
            [self doneAction];
            break;
            
        default:
            break;
    }
}

#pragma mark - tap

- (void)hideKeyboard:(UITapGestureRecognizer *)tap
{
    [_payerField resignFirstResponder];
    [_consigneeField resignFirstResponder];
    [_telField resignFirstResponder];
    [_addressField resignFirstResponder];
}

#pragma mark - layout subviews

- (void)configurationMainView:(UIView *)aView
{
    CGFloat y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height;
    CGRect rect = CGRectMake(_titleLabel.frame.origin.x, y, _titleLabel.frame.size.width, _bottomView.frame.origin.y - y);
    _payMoneyView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _payMoneyView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
}

- (void)configurationBottomView
{
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(14, 12, _bottomView.frame.size.width - 14 * 2, 35)];
    [segmentedControl setSegmentedControlMode: AKSegmentedControlModeButton];
    [segmentedControl setDelegate:self];
    segmentedControl.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:segmentedControl];
    
    [segmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    CGFloat width = segmentedControl.frame.size.width / 2;
    
    UIImage *buttonBackgroundImagePressedLeft = [UIImage imageNamed:@"effect_segmented_pressed_left.png"];
    UIImage *buttonBackgroundImagePressedRight = [UIImage imageNamed:@"effect_segmented_pressed_right.png"];
    
    //返回
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, segmentedControl.frame.size.height)];
    buttonBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBack.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonBack setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    
    //确认付款
    UIButton *buttonDone = [[UIButton alloc] initWithFrame:CGRectMake(buttonBack.frame.origin.x + buttonBack.frame.size.width, 0, width, segmentedControl.frame.size.height)];
    buttonDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [buttonDone setTitle:@"确认付款" forState:UIControlStateNormal];
    [buttonDone.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonDone setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    
    [segmentedControl setButtonsArray:@[buttonBack, buttonDone]];
    [buttonBack release];
    [buttonDone release];
}


#pragma mark - button

- (IBAction)consigneeCheck:(id)sender
{
    _consigneeCheckButton.selected = !_consigneeCheckButton.selected;
}

- (IBAction)paymentCheck:(id)sender
{
    _paymentCheckButton.selected = !_paymentCheckButton.selected;
}

- (IBAction)alipaySelecte:(id)sender
{
    _paymentAlipay.selected = !_paymentAlipay.selected;
    if (_paymentAlipay.selected) {
        [_paymentAlipay setBackgroundColor:[UIColor blueColor]];
        _paymentCreditCard.selected = NO;
        [_paymentCreditCard setBackgroundColor:[UIColor clearColor]];
    }
    else{
        [_paymentAlipay setBackgroundColor:[UIColor clearColor]];
    }
}

- (IBAction)creditCardSelect:(id)sender
{
    _paymentCreditCard.selected = !_paymentCreditCard.selected;
    if(_paymentCreditCard.selected)
    {
        [_paymentCreditCard setBackgroundColor:[UIColor blueColor]];
        _paymentAlipay.selected = NO;
        [_paymentAlipay setBackgroundColor:[UIColor clearColor]];
    }
    else{
        [_paymentCreditCard setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneAction
{
    
}

#pragma mark - public

- (void)setPayMoney:(NSString *)money
{
    _payMoney = money;
    _moneyLabel.text = money;
}


@end
