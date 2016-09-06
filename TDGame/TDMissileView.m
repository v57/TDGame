//
//  TDMissileView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 16.10.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDMissileView.h"

@implementation TDMissileView

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
    
    [self rotateDrawContext:context inRect:rect];
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    
    CGPoint addLines[] =
	{
		CGPointMake(11*u, 7*u),
		CGPointMake(12*u, 8*u),
		CGPointMake(11*u, 9*u),
		CGPointMake(5*u, 9*u),
		CGPointMake(4*u, 10*u),
		CGPointMake(4*u, 6*u),
		CGPointMake(5*u, 7*u),
	};
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
    
    CGContextDrawPath(context, kCGPathFill);
}

@end
