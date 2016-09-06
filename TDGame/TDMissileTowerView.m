//
//  TDMissleTowerView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 25.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDMissileTowerView.h"

@implementation TDMissileTowerView

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
    
    CGContextSetLineWidth(context, u/2);
    CGContextSetStrokeColorWithColor(context, self.foregroundColor.CGColor);
    CGContextMoveToPoint(context, 8*u, 8*u);
    CGContextAddLineToPoint(context, 12*u, 8*u);
    
    CGContextAddEllipseInRect(context, CGRectMake(6*u, 6*u, 4*u, 4*u));
    
	CGContextStrokePath(context);
}

@end
