//
//  XDPiazzaCell.h
//  DoodleTee
//
//  Created by xieyajie on 13-9-13.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPiazzaCell : UITableViewCell
{
    UIView *_topView;
    UIView *_bottomView;
    
    UILabel *_sellLabel;
    UILabel *_buyerLabel;
    UILabel *_commentLabel;
    UILabel *_praiseLabel;
    
    CGSize _cellSize;
}

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) NSInteger sellCount;
@property (nonatomic) NSInteger buyerCount;
@property (nonatomic) NSInteger commentCount;
@property (nonatomic) NSInteger praiseCount;

- (id)initWithStyle:(UITableViewCellStyle)style size:(CGSize)size reuseIdentifier:(NSString *)reuseIdentifier;

@end
