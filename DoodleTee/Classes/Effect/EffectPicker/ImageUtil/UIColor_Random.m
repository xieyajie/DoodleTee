//
//  UIColor_Random.h
//  DoodleTee
//
//  Created by xie yajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "UIColor_Random.h"

@implementation UIColor(Random)

+ (UIColor *)randomColor
{
	static BOOL seeded = NO;
	if (!seeded) {
		seeded = YES;
		srandom(time(NULL));
	}
	CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
	CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor *)randonColorWithRangeForm:(CGFloat)fromValue to:(CGFloat)toValue
{
    
}

@end