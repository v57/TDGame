//
//  TDSoldierView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 04.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDSoldierView.h"

@implementation TDSoldierView

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
	float u = rect.size.width / 4;
    
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(u, u, 2*u, 2*u));
}

@end
