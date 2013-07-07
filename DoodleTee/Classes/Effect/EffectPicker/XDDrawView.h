//
//  XDDrawView.h
//  DoodleTee
//
//  Created by xieyajie on 13-6-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDDrawPicker;
@interface XDDrawView : UIView<UITextViewDelegate>

@property (nonatomic, retain) XDDrawPicker *picker;

@property (nonatomic, retain) UIImage *image;

- (void)clear;


@end
