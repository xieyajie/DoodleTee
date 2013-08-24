//
//  XDTextPicker.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "XDTextPicker.h"

#define FONT_SIZE 40

@interface XDTextPicker ()<UITextViewDelegate>

- (void)textWithBackgroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor;

@end

@implementation XDTextPicker

@synthesize effectView = _effectView;

- (id)initWithEffectViewSize:(CGSize)size
{
    self = [super init];
    if (self) {
        // Custom initialization
        _effectView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _effectView.backgroundColor = [UIColor clearColor];
        _effectView.font = [UIFont systemFontOfSize:FONT_SIZE];
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

#pragma mark - private

- (void)textWithBackgroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor
{
    _effectView.backgroundColor = bgColor;
    _effectView.textColor = titleColor;
}

#pragma mark - public

- (void)textWithType:(XDTextType)type
{
    UIColor *bgColor = nil;
    UIColor *fontColor = nil;
    switch (type) {
        case XDTextTypeClearBgBlackFont:
            bgColor = [UIColor clearColor];
            fontColor = [UIColor blackColor];
            break;
        case XDTextTypeClearBgSkyBlueFont:
            bgColor = [UIColor clearColor];
            fontColor = [UIColor colorWithRed:0 / 255.0 green:170 / 255.0 blue:220 / 255.0 alpha:1.0];
            break;
        case XDTextTypeClearBgRedFont:
            bgColor = [UIColor clearColor];
            fontColor = [UIColor colorWithRed:255 / 255.0 green:0 / 255.0 blue:115 / 255.0 alpha:1.0];
            break;
        case XDTextTypeBlackBgWhiteFont:
            bgColor = [UIColor blackColor];
            fontColor = [UIColor whiteColor];
            break;
        case XDTextTypeSkyBlueBgWhiteFont:
            bgColor = [UIColor colorWithRed:0 / 255.0 green:170 / 255.0 blue:220 / 255.0 alpha:1.0];
            fontColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
    
    [self textWithBackgroundColor:bgColor titleColor:fontColor];
}

- (UIImage *)imageWithContext
{
    UIGraphicsBeginImageContext(_effectView.bounds.size);
    [_effectView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)clear
{
    _effectView.font = [UIFont systemFontOfSize:FONT_SIZE];
    _effectView.text = @"";
    [self textWithType:XDTextTypeClearBgBlackFont];
}

@end
