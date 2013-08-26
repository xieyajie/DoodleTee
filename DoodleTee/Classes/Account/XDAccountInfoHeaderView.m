//
//  XDAccountInfoHeaderView.m
//  DoodleTee
//
//  Created by xieyajie on 13-8-20.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDAccountInfoHeaderView.h"

@implementation XDAccountInfoHeaderView

@synthesize delegate = _delegate;

@synthesize title;
@synthesize section = _section;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSubviews];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    _colorbg = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, 30)];
    _colorbg.backgroundColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:1.0];
    [self addSubview:_colorbg];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleLabel];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 10 - 25, 5, 20, 20)];
    [_button setImage:[UIImage imageNamed:@"pull_up.png"] forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"pull_down.png"] forState:UIControlStateSelected];
    [_button addTarget:self action:@selector(moreOrLessAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTap:)];
    [self addGestureRecognizer:tap];
}

#pragma mark - tap

- (void)headerViewTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self moreOrLessAction:_button];
    }
}

#pragma mark - button action

- (void)moreOrLessAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    BOOL open = button.selected;
    button.selected = !open;
    
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:showMoreInfo:)]) {
        [_delegate headerView:self showMoreInfo:button.selected];
    }
}

#pragma mark - public

- (void)setTitle:(NSString *)string
{
    _titleLabel.text = string;
}

@end
