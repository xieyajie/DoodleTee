//
//  XDSettingViewController.h
//  DoodleTee
//
//  Created by xie yajie on 13-6-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDSettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView *_mainView;
    IBOutlet UIImageView *_bottomImageView;
    IBOutlet UIButton *_backButton;
    IBOutlet UIButton *_overButton;
}

- (IBAction)backAction:(id)sender;

- (IBAction)overAction:(id)sender;

@end
