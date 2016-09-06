//
//  TDBomberTowerView.m
//  TDGame
//
//  Created by Сергей on 22.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDBomberTowerView.h"

@implementation TDBomberTowerView

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
    
	CGContextSetLineWidth(context, 0.5*u);
    CGContextSetStrokeColorWithColor(context, self.foregroundColor.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(4.5*u, 4.5*u, 7*u, 7*u));
	CGContextStrokePath(context);
}

@end
