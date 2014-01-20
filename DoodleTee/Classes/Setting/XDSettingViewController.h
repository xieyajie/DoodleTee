//
//  XDSettingViewController.h
//  DoodleTee
//
//  Created by xie yajie on 13-6-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDViewController.h"

@interface XDSettingViewController : XDViewController<UITableViewDataSource, UITableViewDelegate>
{
    UIView *_mainView;
    UIView *_bottomView;
    UIButton *_backButton;
    UIButton *_overButton;
}

@property (nonatomic, strong) NSString *currentClotheImageName;

- (void)backAction:(id)sender;

- (void)overAction:(id)sender;

@end
