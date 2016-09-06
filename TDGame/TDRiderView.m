//
//  TDRiderView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 04.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDRiderView.h"

@implementation TDRiderView

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
	float u = rect.size.width / 16;
    
    [self rotateDrawContext:context inRect:rect];
    CGContextSetStrokeColorWithColor(context, self.foregroundColor.CGColor);
	CGContextSetLineWidth(context, 2*u);
	CGContextSetLineCap(context, kCGLineCapRound);

    CGContextMoveToPoint(context, 3*u, 8*u);
	CGContextAddLineToPoint(context, 13*u, 8*u);
	CGContextStrokePath(context);
}

@end
