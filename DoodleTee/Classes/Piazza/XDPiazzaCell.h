//
//  XDPiazzaCell.h
//  DoodleTee
//
//  Created by xieyajie on 13-9-13.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDPiazzaCellDelegate;
@interface XDPiazzaCell : UITableViewCell
{
    UIView *_topView;
    UIView *_bottomView;
    
    UILabel *_sellLabel;
    UIButton *_buyerBt;
    UIButton *_commentBt;
    UIButton *_praiseBt;
    
    CGSize _cellSize;
}

@property (nonatomic, unsafe_unretained) id<XDPiazzaCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) NSInteger sellCount;
@property (nonatomic) CGFloat buyerCount;
@property (nonatomic) NSInteger commentCount;
@property (nonatomic) NSInteger praiseCount;

- (id)initWithStyle:(UITableViewCellStyle)style size:(CGSize)size reuseIdentifier:(NSString *)reuseIdentifier;

@end

@protocol XDPiazzaCellDelegate <NSObject>

@required
- (void)piazzaCell:(XDPiazzaCell *)piazzaCell tapBuyAtIndexPath:(NSIndexPath *)indexPath;

- (void)piazzaCell:(XDPiazzaCell *)piazzaCell tapCommentAtIndexPath:(NSIndexPath *)indexPath;

- (void)piazzaCell:(XDPiazzaCell *)piazzaCell tapPraiseAtIndexPath:(NSIndexPath *)indexPath;


@end
