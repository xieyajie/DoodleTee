//
//  UIColor_Random.h
//  DoodleTee
//
//  Created by xie yajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "UIColor_Random.h"

#define COLOR_RAND_MAX 255.0f

@implementation UIColor(Random)

+ (UIColor *)randomColor
{
	static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        srandom(time(NULL));
    }
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat alpha = random()%255 / (255.0f/4.0f);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//黑色系颜色
+ (UIColor *)randomBlackSeries
{
    CGFloat value = random()%255/(255.0f*2.0f);
    return [UIColor colorWithRed: value green: value blue: value alpha: random()%255 / (255.0f/4.0f)];
}

//蓝色系颜色
+ (UIColor *)randomBlueSeries
{
    return [UIColor colorWithRed: random()%255/(255.0f*2.0f) green: random()%255/(255.0f*2.0f) blue: random()%255/(255.0f/2.0f) alpha: random()%255/(255.0f/4.0f)];
}

@end