//
//  XDEditImageController.h
//  DoodleTee
//
//  Created by xieyajie on 14-01-21.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDViewController.h"

#import "AGSimpleImageEditorView.h"

@interface XDEditImageController : XDViewController
{
    AGSimpleImageEditorView *_simpleImageEditorView;
    UIToolbar *_toolbar;
}

- (id)initWithImage:(UIImage *)image;

@end
