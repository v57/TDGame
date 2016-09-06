//
//  TDTurbulenceTowerView.m
//  TDGame
//
//  Created by Сергей on 25.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDTurbulenceTowerView.h"

@implementation TDTurbulenceTowerView

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
    
    CGPoint s = CGPointMake(12*u, 8*u); // start
	CGContextMoveToPoint(context, s.x, s.y);
    
    
	CGPoint cp1 = CGPointMake(12*u, 3*u); // start vector
	CGPoint e = CGPointMake(4*u, 8*u); //finish
	CGPoint cp2 = CGPointMake(4*u, 3*u); //finish vector
	CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
    cp1 = CGPointMake(4*u, 12*u); // start vector
	e = CGPointMake(10*u, 8*u); //finish
	cp2 = CGPointMake(10*u, 11.5*u); //finish vector
	CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);

    
    cp1 = CGPointMake(10*u, 5.5*u); // start vector
	e = CGPointMake(6*u, 8*u); //finish
	cp2 = CGPointMake(6*u, 5.5*u); //finish vector
	CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
    cp1 = CGPointMake(6*u, 9.5*u); // start vector
	e = CGPointMake(8*u, 8*u); //finish
	cp2 = CGPointMake(8*u, 9.5*u); //finish vector
	CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
    
	CGContextStrokePath(context);
}

@end
