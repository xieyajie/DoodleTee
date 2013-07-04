//
//  XDAccountInfoCell.m
//  DoodleTee
//
//  Created by xie yajie on 13-7-4.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDAccountInfoCell.h"

@implementation XDAccountInfoCell

@synthesize nameLabel = _nameLabel;
@synthesize achieveLabel = _achieveLabel;
@synthesize balanceLabel = _balanceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - get

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _nameLabel;
}

- (UILabel *)achieveLabel
{
    if (_achieveLabel == nil) {
        _achieveLabel = [[UILabel alloc] init];
        _achieveLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _achieveLabel;
}

- (UILabel *)balanceLabel
{
    if (_balanceLabel == nil) {
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _balanceLabel;
}

#pragma mark - public

- (void)cellForBasicInfo
{
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(85, 15, 65, 20)];
    name.font = [UIFont systemFontOfSize:16];
    name.backgroundColor = [UIColor clearColor];
    name.text = @"用户名：";
    [self.contentView addSubview:name];
    
    UILabel *achieve = [[UILabel alloc] initWithFrame:CGRectMake(85, name.frame.origin.y + name.frame.size.height + 5, 65, 20)];
    achieve.font = [UIFont systemFontOfSize:16];
    achieve.backgroundColor = [UIColor clearColor];
    achieve.text = @"成就：";
    [self.contentView addSubview:achieve];
    
    UILabel *balance = [[UILabel alloc] initWithFrame:CGRectMake(85, achieve.frame.origin.y + achieve.frame.size.height + 5, 65, 20)];
    balance.font = [UIFont systemFontOfSize:16];
    balance.backgroundColor = [UIColor clearColor];
    balance.text = @"余额：";
    [self.contentView addSubview:balance];
    
    self.nameLabel.frame = CGRectMake(name.frame.origin.x + name.frame.size.width, name.frame.origin.y, 120, 20);
    [self.contentView addSubview:_nameLabel];
    self.achieveLabel.frame = CGRectMake(name.frame.origin.x + name.frame.size.width, achieve.frame.origin.y, 120, 20);
    [self.contentView addSubview:_achieveLabel];
    self.balanceLabel.frame = CGRectMake(name.frame.origin.x + name.frame.size.width, balance.frame.origin.y, 120, 20);
    [self.contentView addSubview:_balanceLabel];
    
    [name release];
    [achieve release];
    [balance release];
}

- (void)cellForLineChart
{
    
}

@end
