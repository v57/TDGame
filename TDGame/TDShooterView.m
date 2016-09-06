//
//  TDShooterView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 20.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDShooterView.h"

@implementation TDShooterView

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
    
    [self drawBounds:rect];
    
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(6*u, 6*u, 4*u, 4*u));
    CGContextDrawPath(context, kCGPathFill);
}

@end
