//
//  XDTemplateViewController.h
//  DoodleTee
//
//  Created by xieyajie on 13-7-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDTemplateViewController : UIViewController
{
    UILabel *_titleLabel;
    
    UIView *_bottomView;
}

- (void)configurationBottomView;

- (void)configurationMainView:(UIView *)view;

@end
