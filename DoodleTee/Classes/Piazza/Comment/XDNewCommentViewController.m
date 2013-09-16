//
//  XDNewCommentViewController.m
//  DoodleTee
//
//  Created by xieyajie on 13-9-16.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDNewCommentViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "LocalDefault.h"

@interface XDNewCommentViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UILabel *_topLabel;
    UITableView *_tableView;
    UITextView *_textView;
}

@end

@implementation XDNewCommentViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.image = [UIImage imageNamed:@"root_bg.png"];
    [self.view addSubview:bgView];
    
    _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 31)];
    _topLabel.font = [UIFont systemFontOfSize:18];
    _topLabel.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0];
    _topLabel.textAlignment = KTextAlignmentCenter;
    _topLabel.text = @"发布评论";
    _topLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    _topLabel.layer.shadowOpacity = 5.0;
    _topLabel.layer.shadowRadius = 10.0;
    _topLabel.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.view addSubview:_topLabel];
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    inputView.backgroundColor = [UIColor colorWithRed:217 / 255.0 green:217 / 255.0 blue:217 / 255.0 alpha:1.0];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
    [backButton setBackgroundImage:[[UIImage imageNamed:@"buttonBg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:backButton];
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(inputView.frame.size.width - 20 - 100, 5, 100, 30)];
    [doneButton setBackgroundImage:[[UIImage imageNamed:@"buttonBg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"发送" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:doneButton];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, 250)];
    _textView.font = [UIFont systemFontOfSize:17.0];
    _textView.textColor = [UIColor whiteColor];
    _textView.backgroundColor = [UIColor blackColor];
    _textView.alpha = 0.7;
    _textView.inputAccessoryView = inputView;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topLabel.frame.origin.y + _topLabel.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (_topLabel.frame.origin.y + _topLabel.frame.size.height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewCommentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.contentView addSubview:_textView];
    }
    
    [_textView becomeFirstResponder];
    
    return cell;
}

#pragma mark - Tabel view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 290;
}

#pragma mark - notification

- (void)keyboardShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    [UIView animateWithDuration:1.0f animations:^{
        _tableView.frame = CGRectMake(0, _topLabel.frame.origin.y + _topLabel.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (_topLabel.frame.origin.y + _topLabel.frame.size.height) - height);
    }];
}

- (void)keyboardChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    [UIView animateWithDuration:1.0f animations:^{
        _tableView.frame = CGRectMake(0, _topLabel.frame.origin.y + _topLabel.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (_topLabel.frame.origin.y + _topLabel.frame.size.height) - height);
    }];
}

- (void)keyboardHide:(NSNotification *)notification
{
    [UIView animateWithDuration:1.0f animations:^{
        _tableView.frame = CGRectMake(0, _topLabel.frame.origin.y + _topLabel.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (_topLabel.frame.origin.y + _topLabel.frame.size.height));
    }];
}

#pragma mark - button action

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneAction:(id)sender
{
    //发送评论
    //？？？？？？
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
