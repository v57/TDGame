//
//  TDStealthSoldierView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 07.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDStealthSoldierView.h"

@implementation TDStealthSoldierView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.foregroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	float u = rect.size.width / 8;
    
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(u, u, 6*u, 6*u));
}

@end
