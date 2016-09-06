//
//  TDCPView.m
//  TDGame
//
//  Created by Сергей on 07.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDCPView.h"

@implementation TDCPView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	float u = rect.size.width/4;
    
    [self rotateDrawContext:context inRect:rect];
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    
    CGPoint addLines[] =
	{
        CGPointMake(1.08*u, 1.12*u),
        CGPointMake(2*u, 1.7*u),
        CGPointMake(2*u, 1.12*u),
        CGPointMake(3.41*u, 2*u),
        CGPointMake(2*u, 2.88*u),
        CGPointMake(2*u, 2.3*u),
        CGPointMake(1.08*u, 2.88*u),
    };
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));

    CGContextDrawPath(context, kCGPathFill);
}

@end
