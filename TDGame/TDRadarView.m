//
//  TDRadarView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 25.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDRadarView.h"

@implementation TDRadarView

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
    CGContextMoveToPoint(context, 3*u, 8*u);
    CGContextAddLineToPoint(context, 13*u, 8*u);
    
	CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, u/2);
    CGContextSetStrokeColorWithColor(context, self.foregroundColor.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(4.5*u, 4.5*u, 7*u, 7*u));
    
	CGContextStrokePath(context);
}

@end
