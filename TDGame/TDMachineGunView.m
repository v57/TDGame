//
//  TDMachineGunView.m
//  TDGame
//
//  Created by Сергей on 25.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDMachineGunView.h"

@implementation TDMachineGunView

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
    
	CGContextSetLineWidth(context, 0.25*u);
    CGContextSetStrokeColorWithColor(context, self.foregroundColor.CGColor);
    
    CGContextAddEllipseInRect(context, CGRectMake(3.5*u, 7*u, 2*u, 2*u));
    CGContextAddEllipseInRect(context, CGRectMake(10.5*u, 7*u, 2*u, 2*u));
    CGContextAddEllipseInRect(context, CGRectMake(5.25*u, 3.75*u, 2*u, 2*u));
    CGContextAddEllipseInRect(context, CGRectMake(8.75*u, 3.75*u, 2*u, 2*u));
    CGContextAddEllipseInRect(context, CGRectMake(5.25*u, 10.25*u, 2*u, 2*u));
    CGContextAddEllipseInRect(context, CGRectMake(8.75*u, 10.25*u, 2*u, 2*u));
    
	CGContextStrokePath(context);
}

@end
