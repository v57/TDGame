//
//  TDPlayButtonView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 30.11.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDPlayButtonView.h"

@implementation TDPlayButtonView
-(id)initWithFrame:(CGRect)frame andPlay:(BOOL)play {
    self = [self initWithFrame:frame];
    self.play = play;
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    float u = rect.size.width/16;
    CGContextSetLineWidth(context, 3);
    
    if(self.play) {
        CGContextSetRGBStrokeColor(context, .0f, .0f, .0f, 1.0f);
        CGContextMoveToPoint(context, 6*u,5*u);
        CGContextAddLineToPoint(context, 6*u,11*u);
        
        CGContextMoveToPoint(context, 10*u,5*u);
        CGContextAddLineToPoint(context, 10*u,11*u);
        CGContextStrokePath(context);

    }
    else {
        CGContextSetRGBFillColor(context, .0f, .0f, .0f, 1.0f);
        CGPoint addLines[] =
        {
            CGPointMake(5*u, 5*u),
            CGPointMake(11*u, 8*u),
            CGPointMake(5*u, 11*u),
        };
        CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
        
        CGContextFillPath(context);
    }
    CGContextSetLineWidth(context, 2);
    [self drawRoundRect:CGRectMake(0.5*u, 0.5*u, 15*u, 15*u) withRadius:2.5*u];
    [self drawRoundRect:CGRectMake(2*u, 2*u, 12*u, 12*u) withRadius:u];
}
- (void)drawRoundRect:(CGRect)rect withRadius:(CGFloat)radius
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextStrokePath(context);
}

@end
