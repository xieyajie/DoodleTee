//
//  XDCustomMadeViewController.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDCustomMadeViewController : UIViewController

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) UIView *bottomView;

- (void)backAction;

- (void)doneAction;

@end
