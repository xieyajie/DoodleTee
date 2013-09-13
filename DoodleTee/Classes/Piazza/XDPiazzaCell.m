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

@synthesize headerView = _headerView;
@synthesize nameLabel = _nameLabel;
@synthesize imageView = _imageView;

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
    _headerView.backgroundColor = [UIColor whiteColor];
    [_topView addSubview:_headerView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerView.frame.origin.x + _headerView.frame.size.width + 10, 0, 100, _topView.frame.size.height)];
    _nameLabel.numberOfLines = 0;
    _nameLabel.minimumFontSize = 13.0;
    _nameLabel.backgroundColor = [UIColor redColor];
    [_topView addSubview:_nameLabel];
    
    _sellLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width + 5, 0, _topView.frame.size.width - (_nameLabel.frame.origin.x + _nameLabel.frame.size.width + 10), _topView.frame.size.height)];
    _sellLabel.textAlignment = KTextAlignmentRight;
    _sellLabel.backgroundColor = [UIColor yellowColor];
    [_topView addSubview:_sellLabel];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height + 5, _cellSize.width, 300)];
    _imageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_imageView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, _imageView.frame.origin.y + _imageView.frame.size.height + 5, _cellSize.width  - 20, 40.0)];
    _bottomView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_bottomView];
    
    CGFloat width = (_bottomView.frame.size.width - 4 * 5) / 3;
    _buyerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, width, _bottomView.frame.size.height)];
    _buyerLabel.textAlignment = KTextAlignmentCenter;
    [_bottomView addSubview:_buyerLabel];
    
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(width + 5 * 2, 0, width, _bottomView.frame.size.height)];
    _commentLabel.textAlignment = KTextAlignmentCenter;
    [_commentLabel addSubview:_buyerLabel];
    
    _praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake((width + 5) * 2 + 5, 0, width, _bottomView.frame.size.height)];
    _praiseLabel.textAlignment = KTextAlignmentCenter;
    [_praiseLabel addSubview:_buyerLabel];
}

#pragma mark - set

- (void)setSellCount:(NSInteger)count
{
    if (_sellCount != count) {
        _sellCount = count;
    }
}

- (void)setBuyerCount:(NSInteger)count
{
    if (_buyerCount != count) {
        _buyerCount = count;
    }
}

- (void)setCommentCount:(NSInteger)count
{
    if (_commentCount != count) {
        _commentCount = count;
    }
}

- (void)setPraiseCount:(NSInteger)count
{
    if (_praiseCount != count) {
        _praiseCount = count;
    }
}

@end
