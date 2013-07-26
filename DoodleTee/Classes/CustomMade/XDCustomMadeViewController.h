//
//  XDCustomMadeViewController.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDCustomMadeViewController : UIViewController

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomView;

- (id)initWithClothImage:(UIImage *)image;

- (void)backAction;

- (void)doneAction;

@end
