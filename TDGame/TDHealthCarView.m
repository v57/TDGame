//
//  TDHealthCarView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 07.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDHealthCarView.h"

@implementation TDHealthCarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	float u = rect.size.height/16;
    
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(2*u, 2*u, 12*u, 12*u));

    CGPoint addLines[] =
	{
        CGPointMake(7*u, 7*u),
        CGPointMake(7*u, 4*u),
        CGPointMake(9*u, 4*u),
        CGPointMake(9*u, 7*u),
        CGPointMake(12*u, 7*u),
        CGPointMake(12*u, 9*u),
        CGPointMake(9*u, 9*u),
        CGPointMake(9*u, 12*u),
        CGPointMake(7*u, 12*u),
        CGPointMake(7*u, 9*u),
        CGPointMake(4*u, 9*u),
        CGPointMake(4*u, 7*u),
    };
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextDrawPath(context, kCGPathFill);
}

@end
