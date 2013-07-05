//
//  XDTextPicker.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDTextPicker.h"

#define FONT_SIZE 20

@interface XDTextPicker ()<UITextViewDelegate>

@end

@implementation XDTextPicker

@synthesize effectView = _effectView;

- (id)initWithEffectViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        _effectView = [[UITextView alloc] initWithFrame:frame];
        _effectView.backgroundColor = [UIColor magentaColor];
        _effectView.font = [UIFont systemFontOfSize:FONT_SIZE];
//        _effectView.returnKeyType = UIReturnKeyDone;
//        _effectView.delegate = self;
    }
    return self;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text isEqualToString: @"\n"])
    {
        [_effectView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - public

- (void)textWithState:(XDTextState)state
{
    UIColor *bgColor = nil;
    UIColor *fontColor = nil;
    switch (state) {
        case XDTextStateClearBgBlackFont:
            bgColor = [UIColor clearColor];
            fontColor = [UIColor blackColor];
            break;
        case XDTextStateClearBgSkyBlueFont:
            bgColor = [UIColor clearColor];
            fontColor = [UIColor blueColor];
            break;
        case XDTextStateClearBgRedFont:
            bgColor = [UIColor clearColor];
            fontColor = [UIColor purpleColor];
            break;
        case XDTextStateBlackBgWhiteFont:
            bgColor = [UIColor blackColor];
            fontColor = [UIColor whiteColor];
            break;
        case XDTextStateSkyBlueBgWhiteFont:
            bgColor = [UIColor blueColor];
            fontColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
    
    [self textWithBackgroundColor:bgColor titleColor:fontColor];
}

- (void)textWithBackgroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor
{
    _effectView.backgroundColor = bgColor;
    _effectView.textColor = titleColor;
}


@end
