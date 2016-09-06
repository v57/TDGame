//
//  TDSniperView.m
//  TDGame
//
//  Created by Сергей on 21.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDSniperView.h"
#import "TDTower.h"

@implementation TDSniperView

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
    CGContextMoveToPoint(context, 4.5*u, 8*u);
    CGContextAddLineToPoint(context, 11.5*u, 8*u);
    
	CGContextStrokePath(context);
}

@end
