//
//  TDATCView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 07.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDATCView.h"

@implementation TDATCView

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
        CGPointMake(3*u, 4*u),
        CGPointMake(13*u, 4*u),
        CGPointMake(13*u, 6.5*u),
        CGPointMake(9*u, 6.5*u),
        CGPointMake(9*u, 9.5*u),
        CGPointMake(13*u, 9.5*u),
        CGPointMake(13*u, 12*u),
        CGPointMake(3*u, 12*u),
        CGPointMake(3*u, 9.5*u),
        CGPointMake(6.5*u, 9.5*u),
        CGPointMake(6.5*u, 6.5*u),
        CGPointMake(3*u, 6.5*u),
	};
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));

    CGContextDrawPath(context, kCGPathFill);
}

@end
