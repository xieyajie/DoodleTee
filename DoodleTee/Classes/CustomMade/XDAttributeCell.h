//
//  XDAttributeCell.h
//  GroupTableViewDemo
//
//  Created by xieyajie on 13-7-2.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDAttributeCell : UITableViewCell
{
    UILabel *_attributeLabel;
    UILabel *_valueLabel;
}

@property (nonatomic, strong, setter = setAttributeTitle:) NSString *title;

@property (nonatomic, strong, setter = setValue:) NSString *value;

@end
