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
    
    UIView *_mainView;
    
    UIView *_bottomView;
}

@property (nonatomic, retain) UIView *mainView;

- (void)configurationBottomView;

- (void)configurationMainView;

@end
