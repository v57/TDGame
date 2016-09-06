//
//  TDTruckView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 07.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDTruckView.h"

@implementation TDTruckView

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
	float u = rect.size.height/8;
    
    [self rotateDrawContext:context inRect:rect];
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(u, 2*u, 6*u, 4*u));
}

@end
