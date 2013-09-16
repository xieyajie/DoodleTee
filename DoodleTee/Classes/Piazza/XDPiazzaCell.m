//
//  XDPiazzaCell.m
//  DoodleTee
//
//  Created by xieyajie on 13-9-13.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDPiazzaCell.h"
#import "LocalDefault.h"

@implementation XDPiazzaCell

@synthesize delegate = _delegate;
@synthesize indexPath = _indexPath;

@synthesize headerView = _headerView;
@synthesize nameLabel = _nameLabel;
@synthesize imageView = _subImageView;

@synthesize sellCount = _sellCount;
@synthesize buyerCount = _buyerCount;
@synthesize commentCount = _commentCount;
@synthesize praiseCount = _praiseCount;

- (id)initWithStyle:(UITableViewCellStyle)style size:(CGSize)size reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _cellSize = size;
        [self initSubviews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - layout subviews

- (void)initSubviews
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, _cellSize.width - 20, 50.0)];
    _topView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_topView];
    
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    _headerView.backgroundColor = [UIColor clearColor];
    [_topView addSubview:_headerView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerView.frame.origin.x + _headerView.frame.size.width + 10, 0, 100, _topView.frame.size.height)];
    _nameLabel.numberOfLines = 0;
    _nameLabel.minimumFontSize = 13.0;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_topView addSubview:_nameLabel];
    
    _sellLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width + 5, 0, _topView.frame.size.width - (_nameLabel.frame.origin.x + _nameLabel.frame.size.width + 10), _topView.frame.size.height)];
    _sellLabel.textAlignment = KTextAlignmentRight;
    _sellLabel.backgroundColor = [UIColor clearColor];
    _sellLabel.textColor = [UIColor whiteColor];
    _sellLabel.font = [UIFont systemFontOfSize:14.0];
    [_topView addSubview:_sellLabel];
    
    _subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height + 10, _cellSize.width, 290)];
    _subImageView.contentMode = UIViewContentModeScaleAspectFit;
    _subImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_subImageView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, _subImageView.frame.origin.y + _subImageView.frame.size.height + 10, _cellSize.width  - 20, 40.0)];
    _bottomView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_bottomView];
    
    CGFloat width = (_bottomView.frame.size.width - 4 * 5) / 3;
    _buyerBt = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, width, _bottomView.frame.size.height)];
    _buyerBt.titleLabel.textAlignment = KTextAlignmentCenter;
    _buyerBt.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_buyerBt addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_buyerBt];
    
    _commentBt = [[UIButton alloc] initWithFrame:CGRectMake(width + 5 * 2, 0, width, _bottomView.frame.size.height)];
    _commentBt.titleLabel.textAlignment = KTextAlignmentCenter;
    _commentBt.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_commentBt addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_commentBt];
    
    _praiseBt = [[UIButton alloc] initWithFrame:CGRectMake((width + 5) * 2 + 5, 0, width, _bottomView.frame.size.height)];
    _praiseBt.titleLabel.textAlignment = KTextAlignmentCenter;
    _praiseBt.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_praiseBt addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_praiseBt];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _bottomView.frame.origin.y + _bottomView.frame.size.height + 10, _cellSize.width, 2)];
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
}

#pragma mark - set

- (void)setSellCount:(NSInteger)count
{
    if (_sellCount != count) {
        _sellCount = count;
        if (count < 1000) {
            _sellLabel.text = [NSString stringWithFormat:@"卖出 %i件", count];
        }
        else
        {
            _sellLabel.text = [NSString stringWithFormat:@"卖出 %ik+件", (count / 1000)];
        }
    }
}

- (void)setBuyerCount:(CGFloat)count
{
    if (_buyerCount != count) {
        _buyerCount = count;
        [_buyerBt setTitle:[NSString stringWithFormat:@"￥%.1f 购买", count] forState:UIControlStateNormal];
    }
}

- (void)setCommentCount:(NSInteger)count
{
    if (_commentCount != count) {
        _commentCount = count;
        if (count < 1000) {
            [_commentBt setTitle:[NSString stringWithFormat:@"评论 %i", count] forState:UIControlStateNormal];
        }
        else
        {
            [_commentBt setTitle:[NSString stringWithFormat:@"评论 %ik+", (count / 1000)] forState:UIControlStateNormal];
        }
    }
}

- (void)setPraiseCount:(NSInteger)count
{
    if (_praiseCount != count) {
        _praiseCount = count;
        if (count < 1000) {
            [_praiseBt setTitle:[NSString stringWithFormat:@"赞 %i", count] forState:UIControlStateNormal];
        }
        else
        {
            [_praiseBt setTitle:[NSString stringWithFormat:@"赞 %ik+", (count / 1000)] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - button action

- (void)buyAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(piazzaCell:tapBuyAtIndexPath:)]) {
        [_delegate piazzaCell:self tapBuyAtIndexPath:self.indexPath];
    }
}

- (void)commentAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(piazzaCell:tapCommentAtIndexPath:)]) {
        [_delegate piazzaCell:self tapCommentAtIndexPath:self.indexPath];
    }
}

- (void)praiseAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(piazzaCell:tapPraiseAtIndexPath:)]) {
        [_delegate piazzaCell:self tapPraiseAtIndexPath:self.indexPath];
    }
}

@end
