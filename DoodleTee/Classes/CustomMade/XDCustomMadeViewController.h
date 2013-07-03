//
//  XDCustomMadeViewController.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDCustomMadeViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) IBOutlet UIView *bottomView;

- (IBAction)backAction;

- (IBAction)doneAction;

@end
