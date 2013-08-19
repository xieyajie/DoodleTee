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

#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"

#import "XDDataCenter.h"
#import "LocalDefault.h"

@implementation Product
@synthesize price = _price;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize orderId = _orderId;

@end


@interface XDPayMoneyViewController ()<UITextFieldDelegate, AKSegmentedControlDelegate>
{
    Product *_product;
}

@property (nonatomic, strong) UIView *payMoneyView;

@property (nonatomic, strong) Product *product;

@end

@implementation XDPayMoneyViewController

@synthesize payMoneyView = _payMoneyView;

@synthesize productInfo = _productInfo;

@synthesize product = _product;

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
    [self configurationBottomView];
    [self.view addSubview:_bottomView];
    
    [self configurationMainView:_payMoneyView];
    
    _moneyLabel.backgroundColor = [UIColor clearColor];
    
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
    if ([self checkOrderInfo]) {
        //上传订单
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserName];
        [[XDDataCenter sharedCenter] orderWithUserName:userName colcor:[_productInfo objectForKey:kSETTINGCOLOR] material:[_productInfo objectForKey:kSETTINGMATERIAL] size:[_productInfo objectForKey:kSETTINGSIZE] brand:[_productInfo objectForKey:kSETTINGBRAND] count:[[_productInfo objectForKey:kSETTINGCOUNT] integerValue] money:[[_productInfo objectForKey:kSETTINGMONEY] floatValue] complete:^(id result){
            if (result) {
                //
            }
        }onError:^(NSError *error){
            
        }];
    }
}

#pragma mark - private

- (Product *)product
{
    if (_product) {
        _product = [[Product alloc] init];
    }
    
    return _product;
}

/*
 *随机生成15位订单号,外部商户根据自己情况生成订单号
 */
- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	__autoreleasing NSMutableString *result = [[NSMutableString alloc] init];
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

//检查订单信息完整性
- (BOOL)checkOrderInfo
{
    UIAlertView *error = [[UIAlertView alloc] init];
    error.title = @"信息错误";
    [error addButtonWithTitle:@"确定"];
    
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    if ([_payerField.text stringByTrimmingCharactersInSet:charSet].length < 1) {
        error.message = @"请填写付款人";
        [error show];
        
        return NO;
    }
    else if ([_consigneeField.text stringByTrimmingCharactersInSet:charSet].length < 1)
    {
        error.message = @"请填写收货人";
        [error show];
        
        return NO;
    }
    else if ([_addressField.text stringByTrimmingCharactersInSet:charSet].length < 1)
    {
        error.message = @"请填写收货地址";
        [error show];
        
        return NO;
    }
    else if ([_telField.text stringByTrimmingCharactersInSet:charSet].length < 1)
    {
        error.message = @"请填写电话号码";
        [error show];
        
        return NO;
    }
    else if (![self isMobileNumber:[_telField.text stringByTrimmingCharactersInSet:charSet]])
    {
        error.message = @"请填写正确的电话号码";
        [error show];
        
        return NO;
    }
    else if (_paymentCreditCard.selected == NO && _paymentAlipay.selected == NO)
    {
        error.message = @"请选择支付方式";
        [error show];
        
        return NO;
    }
    
    return YES;
}

//电话号码匹配
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//上传订单
- (void)uploadOrder
{
    
}

//选择支付宝
- (void)alixPayDone
{
    /*
     *商户的唯一的parnter和seller。
     *本demo将parnter和seller信息存于（AlixPayDemo-Info.plist）中,外部商户可以考虑存于服务端或本地其他地方。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    //如果partner和seller数据存于其他位置,请改写下面两行代码
    NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     *由于demo的局限性，本demo中的公私钥存放在AlixPayDemo-Info.plist中,外部商户可以存放在服务端或本地其他地方。
     */
    //将商品信息赋予AlixPayOrder的成员变量
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = self.product.subject; //商品标题
    order.productDescription = self.product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",self.product.price]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    //    order.extraParams = @{@"paizi", @"123"; @"cailiao", @"123"; @"size", @"123"; @"color", @"123"; @"count", @"123"};
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
    NSString *appScheme = @"DoodleTee";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        
        if (ret == kSPErrorAlipayClientNotInstalled) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"您还没有安装支付宝快捷支付，请先安装。"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView setTag:123];
            [alertView show];
        }
        else if (ret == kSPErrorSignError) {
            NSLog(@"签名错误！");
        }
        
    }
}


#pragma mark - public

- (void)setProductInfo:(NSDictionary *)aInfo
{
    _productInfo = aInfo;
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f", [[aInfo objectForKey:kSETTINGMONEY] floatValue]];
    self.product.price = [[aInfo objectForKey:kSETTINGMONEY] floatValue];
}


@end
