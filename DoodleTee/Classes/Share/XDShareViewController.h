//
//  XDShareViewController.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDShareViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil shareImage:(UIImage *)image;

- (IBAction)cancel:(id)sender;

@end
