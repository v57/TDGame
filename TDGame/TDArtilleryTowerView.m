//
//  TDArtilleryTowerView.m
//  TDGame
//
//  Created by Сергей on 29.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDArtilleryTowerView.h"

@implementation TDArtilleryTowerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dotPositionLoaded = 0.5f;
        self.dotPositionUnloaded = 1.3125f;
        self.dotPosition = self.dotPositionLoaded;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float u = rect.size.height/16;
    CGContextSetStrokeColorWithColor(context, self.foregroundColor.CGColor);
	CGContextSetLineWidth(context, u);
    
    CGContextMoveToPoint(context, 15.5*u, 10*u);
	CGContextAddArcToPoint(context, 15.5*u, 15.5*u, 8*u, 15.5*u, 2.5*u);
    CGContextAddArcToPoint(context, 0.5*u, 15.5*u, 0.5*u, 8*u, 2.5*u);
    CGContextAddArcToPoint(context, 0.5*u, 0.5*u, 8*u, 0.5*u, 2.5*u);
    CGContextAddArcToPoint(context, 15.5*u, 0.5*u, 15.5*u, 6*u, 2.5*u);
    CGContextAddLineToPoint(context, 15.5*u, 6*u);
    CGContextStrokePath(context);

    CGContextMoveToPoint(context, 14*u, 10*u);
	CGContextAddArcToPoint(context, 14*u, 14*u, 8*u, 14*u, u);
    CGContextAddArcToPoint(context, 2*u, 14*u, 2*u, 8*u, u);
    CGContextAddArcToPoint(context, 2*u, 2*u, 8*u, 2*u, u);
    CGContextAddArcToPoint(context, 14*u, 2*u, 14*u, 6*u, u);
    CGContextAddLineToPoint(context, 14*u, 6*u);
    CGContextStrokePath(context);

    CGContextMoveToPoint(context, 16.5*u, 6*u);
	CGContextAddArcToPoint(context, 16.5*u, 3.25*u, 21.25*u, 3.25*u, 2.5*u);
    CGContextAddArcToPoint(context, 26*u, 3.25*u, 26*u, 8*u, 2.5*u);
    CGContextAddArcToPoint(context, 26*u, 12.75*u, 21.25*u, 12.75*u, 2.5*u);
    CGContextAddArcToPoint(context, 16.5*u, 12.75*u, 16.5*u, 10*u, 2.5*u);
    CGContextAddLineToPoint(context, 16.5*u, 10*u);
    CGContextStrokePath(context);
    
    float x = self.dotPosition * rect.size.height - u;
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(x, 7*u, 2*u, 2*u));
    CGContextDrawPath(context, kCGPathFill);
    
    CGRect r = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetHeight(rect), CGRectGetHeight(rect));
    [self rotateTower:r];
    
    CGContextSetLineWidth(context, u/2);
    CGContextMoveToPoint(context, 4*u, 8*u);
    CGContextAddLineToPoint(context, 10.25*u, 8*u);
    CGContextStrokePath(context);
    
    CGPoint addLines[] =
	{
		CGPointMake(10.25*u, 7.375*u),
		CGPointMake(12*u, 8*u),
		CGPointMake(10.25*u, 8.625*u),
	};
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextDrawPath(context, kCGPathFill);
}

@end
