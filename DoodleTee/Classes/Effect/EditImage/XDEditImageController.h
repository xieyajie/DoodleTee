//
//  XDEditImageController.h
//  DoodleTee
//
//  Created by xieyajie on 14-01-21.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AGSimpleImageEditorView.h"

@interface XDEditImageController : UIViewController
{
    AGSimpleImageEditorView *_simpleImageEditorView;
    UIToolbar *_toolbar;
}

- (id)initWithImage:(UIImage *)image;

@end
