//
//  TDLaserTowerView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 25.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDLaserTowerView.h"

@implementation TDLaserTowerView

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
    CGContextMoveToPoint(context, 2*u, 8*u);
    CGContextAddLineToPoint(context, 14*u, 8*u);
    
	CGContextStrokePath(context);
}

@end
