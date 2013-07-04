//
//  XDAttributeCell.m
//  GroupTableViewDemo
//
//  Created by xieyajie on 13-7-2.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDAttributeCell.h"

@implementation XDAttributeCell

@synthesize title;
@synthesize value;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initSubviews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAttributeTitle:(NSString *)str
{
    _attributeLabel.text = str;
}

- (void)setValue:(NSString *)str
{
    _valueLabel.text = str;
}

- (void)initSubviews
{
    _attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 70, self.contentView.frame.size.height)];
    _attributeLabel.backgroundColor = [UIColor clearColor];
    _attributeLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:_attributeLabel];
    
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, self.contentView.frame.size.height)];
    _valueLabel.backgroundColor = [UIColor clearColor];
    _valueLabel.textColor = [UIColor grayColor];
    _valueLabel.font = [UIFont boldSystemFontOfSize:20];
//    _valueLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_valueLabel];

    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
