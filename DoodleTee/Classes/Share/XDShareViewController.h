//
//  XDShareViewController.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDViewController.h"

@interface XDShareViewController : XDViewController<UITableViewDataSource, UITableViewDelegate>
{
    UIToolbar *_toolbar;
    UITableView *_tableView;
}

@property (nonatomic, strong) UITableView *tableView;


- (id)initWithShareImage:(UIImage *)image;

- (void)cancel:(id)sender;

@end
