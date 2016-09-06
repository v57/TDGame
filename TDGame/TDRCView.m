//
//  TDRCView.m
//  TDGame
//
//  Created by Сергей on 07.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDRCView.h"

@implementation TDRCView

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
    
    [self rotateDrawContext:context inRect:rect];
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(2*u, 5*u, 12*u, 6*u));
}

@end
