//
//  TDArtilleryTankView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 06.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDArtilleryTankView.h"

@implementation TDArtilleryTankView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.angle = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	float u = rect.size.width/8;
    
    [self rotateDrawContext:context inRect:rect];
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
	CGContextFillRect(context, CGRectMake(u, u, 6*u, 6*u));
    
    CGContextSetLineWidth(context, u);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    float ux = 2*u*sinf(self.angle);
    float uy = 2*u*cosf(self.angle);
    CGContextMoveToPoint(context, 4*u+uy, 4*u-ux);
    CGContextAddLineToPoint(context, 4*u-uy, 4*u+ux);
    
	CGContextStrokePath(context);
}

@end
