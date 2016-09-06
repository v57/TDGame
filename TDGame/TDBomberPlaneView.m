//
//  TDBomberPlaneView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 06.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDBomberPlaneView.h"

@implementation TDBomberPlaneView

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
	float u = rect.size.width/16;
    
    [self rotateDrawContext:context inRect:rect];
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    
    CGPoint addLines[] =
	{
		CGPointMake(5*u, u),
		CGPointMake(11*u, 8*u),
		CGPointMake(5*u, 15*u),
	};
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
    
    CGContextDrawPath(context, kCGPathFill);
}

@end
