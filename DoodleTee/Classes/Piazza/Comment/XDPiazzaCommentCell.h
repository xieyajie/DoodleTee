//
//  XDPiazzaCommentCell.h
//  DoodleTee
//
//  Created by xieyajie on 13-9-16.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPiazzaCommentCell : UITableViewCell
{
    UIView *_mainView;
}

@property (nonatomic) CGSize customViewSize;

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UITextView *contentView;

@end
