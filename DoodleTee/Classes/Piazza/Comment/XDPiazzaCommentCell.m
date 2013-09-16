//
//  XDPiazzaCommentCell.m
//  DoodleTee
//
//  Created by xieyajie on 13-9-16.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDPiazzaCommentCell.h"

#import "LocalDefault.h"

@implementation XDPiazzaCommentCell

@synthesize customViewSize = _customViewSize;

@synthesize headerView = _headerView;
@synthesize nameLabel = _nameLabel;
@synthesize dateLabel = _dateLabel;
@synthesize contentTextView = _contentTextView;

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

- (void)initSubviews
{
    _customViewSize = CGSizeMake(320, 100);
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, _customViewSize.width - 20, _customViewSize.height - 20)];
    _mainView.backgroundColor = [UIColor blackColor];
    _mainView.alpha = 0.7;
    _mainView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _mainView.layer.shadowOpacity = 5.0;
    _mainView.layer.shadowRadius = 10.0;
    _mainView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.contentView addSubview:_mainView];
    
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    _headerView.backgroundColor = [UIColor clearColor];
    [_mainView addSubview:_headerView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerView.frame.origin.x + _headerView.frame.size.width + 10, 0, 100, 20)];
    _nameLabel.numberOfLines = 0;
    _nameLabel.minimumFontSize = 13.0;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_mainView addSubview:_nameLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mainView.frame.size.width - 5 - 100, 0, 100, 20)];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.font = [UIFont boldSystemFontOfSize:14.0];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textAlignment = KTextAlignmentRight;
    [_mainView addSubview:_dateLabel];

    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, _headerView.frame.origin.y + _headerView.frame.size.height + 10, _mainView.frame.size.width - 20, _mainView.frame.size.height - 5 - (_headerView.frame.origin.y + _headerView.frame.size.height + 10))];
    _contentTextView.font = [UIFont systemFontOfSize:15.0];
    _contentTextView.userInteractionEnabled = NO;
    [_mainView addSubview:_contentTextView];
}

#pragma mark - set

- (void)setCustomViewSize:(CGSize)size
{
    _customViewSize = size;
    
    _mainView.frame = CGRectMake(10, 10, _customViewSize.width, self.frame.size.height);
    _dateLabel.frame = CGRectMake(_mainView.frame.size.width - 5 - 100, 0, 100, 20);
    _contentTextView.frame = CGRectMake(10, _headerView.frame.origin.y + _headerView.frame.size.height + 10, _mainView.frame.size.width - 20, _mainView.frame.size.height - 5 - (_headerView.frame.origin.y + _headerView.frame.size.height + 10));}

@end
