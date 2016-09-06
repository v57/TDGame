//
//  TDFlyerView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 05.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDFlyerView.h"

@implementation TDFlyerView

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
	float u = rect.size.height/2;
    
    [self rotateDrawContext:context inRect:rect];
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    
    CGPoint addLines[] =
	{
		CGPointMake(1.62*u, u),
		CGPointMake(0.38*u, 0.25*u),
		CGPointMake(0.38*u, 1.75*u),
	};
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));

    CGContextDrawPath(context, kCGPathFill);
}

@end
