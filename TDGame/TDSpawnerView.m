//
//  TDSpawnerView.m
//  TDGame
//
//  Created by Сергей on 26.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDSpawnerView.h"

@implementation TDSpawnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dashPhase = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    float u = rect.size.width / 16;
	CGFloat dashPattern[2] = {u/2, 2*u};
	size_t dashCount = 2;

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.foregroundColor.CGColor);
    CGContextSetLineDash(context, self.dashPhase, dashPattern, dashCount);
    CGContextStrokeRectWithWidth(context, rect, u);
}

@end
