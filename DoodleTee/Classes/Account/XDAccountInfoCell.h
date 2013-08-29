//
//  XDAccountInfoCell.h
//  DoodleTee
//
//  Created by xie yajie on 13-7-4.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface XDAccountInfoCell : UITableViewCell
{
    //for header info
    UIImageView *_headerView;
    UILabel *_nameLabel;
    UILabel *_achieveLabel;
    UILabel *_balanceLabel;
    
    //for Consigne info
    UILabel *_consigneTitleLabel;
    UILabel *_consigneInfoLabel;
}

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *achieveLabel;
@property (nonatomic, strong) UILabel *balanceLabel;

@property (nonatomic, strong) UILabel *consigneTitleLabel;
@property (nonatomic, strong) UILabel *consigneInfoLabel;

- (void)cellForHeaderView;

- (void)cellForLineChart;

- (void)cellForConsigne;

@end
