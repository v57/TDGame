//
//  TDAATowerView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 26.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDAATowerView.h"

@implementation TDAATowerView

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
    [self rotateTower:rect];
    
    CGContextSetLineWidth(context, u);
    CGContextSetStrokeColorWithColor(context, self.foregroundColor.CGColor);
    
    CGContextMoveToPoint(context, 3.5*u, 6*u);
    CGContextAddLineToPoint(context, 12.5*u, 6*u);
    CGContextMoveToPoint(context, 3.5*u, 10*u);
    CGContextAddLineToPoint(context, 12.5*u, 10*u);
    CGContextMoveToPoint(context, 6.5*u, 6.5*u);
    CGContextAddLineToPoint(context, 6.5*u, 9.5*u);
    
	CGContextStrokePath(context);
}

@end
