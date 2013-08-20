//
//  XDAccountInfoHeaderView.h
//  DoodleTee
//
//  Created by xieyajie on 13-8-20.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDAccountInfoHeaderViewDelegate;

@interface XDAccountInfoHeaderView : UIView
{
    UIView *_colorbg;
    UILabel *_titleLabel;
    UIButton *_button;
    
    NSInteger _section;
}

@property (nonatomic, unsafe_unretained) id<XDAccountInfoHeaderViewDelegate> delegate;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, unsafe_unretained) NSInteger section;

@end

@protocol XDAccountInfoHeaderViewDelegate <NSObject>

@required
- (void)headerView:(XDAccountInfoHeaderView *)headerView showMoreInfo:(BOOL)open;

@end
