//
//  XDAccountInfoViewController.h
//  DoodleTee
//
//  Created by xie yajie on 13-7-4.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDAccountInfoViewController : UIViewController

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) UIView *bottomView;

- (void)backAction;

@end
