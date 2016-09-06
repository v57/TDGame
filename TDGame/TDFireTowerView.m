//
//  TDFireTowerView.m
//  TDGame
//
//  Created by Сергей on 22.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDFireTowerView.h"
#import "TDTower.h"

@implementation TDFireTowerView

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
		CGPointMake(12*u, 8*u),
		CGPointMake(4.5*u, 6*u),
		CGPointMake(4.5*u, 10*u),
	};
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
    
    CGContextDrawPath(context, kCGPathFill);
}

@end
