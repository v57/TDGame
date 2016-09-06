//
//  TDTankView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 05.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDTankView.h"

@implementation TDTankView

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
		CGPointMake(12*u, 4*u),
		CGPointMake(12*u, 6.5*u),
		CGPointMake(8*u, 6.5*u),
		CGPointMake(8*u, 7.5*u),
		CGPointMake(14*u, 7.5*u),
		CGPointMake(14*u, 8.5*u),
		CGPointMake(8*u, 8.5*u),
		CGPointMake(8*u, 9.5*u),
		CGPointMake(12*u, 9.5*u),
		CGPointMake(12*u, 12*u),
		CGPointMake(2*u, 12*u),
		CGPointMake(2*u, 9.5*u),
		CGPointMake(5.5*u, 9.5*u),
		CGPointMake(5.5*u, 6.5*u),
		CGPointMake(2*u, 6.5*u),
		CGPointMake(2*u, 4*u),
	};
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));

    CGContextDrawPath(context, kCGPathFill);
}

@end
