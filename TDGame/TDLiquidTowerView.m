//
//  TDLiquidTowerView.m
//  TDGame
//
//  Created by Сергей on 22.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDLiquidTowerView.h"
#import "TDTower.h"

@implementation TDLiquidTowerView

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
    
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
	CGContextSetLineWidth(context, 0.5*u);
    
    CGPoint addLines[] =
	{
		CGPointMake(11*u, 8*u),
		CGPointMake(5*u, 5*u),
		CGPointMake(6.5*u, 8*u),
		CGPointMake(5*u, 11*u),
	};
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
	CGContextClosePath(context);
    
	CGContextStrokePath(context);
}

@end
