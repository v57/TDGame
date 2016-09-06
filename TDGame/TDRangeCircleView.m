//
//  TDRangeCircleView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 01.10.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDRangeCircleView.h"

@implementation TDRangeCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(CGRectGetMidX(frame), CGRectGetMidY(frame), 0.0f, 0.0f)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [UIView animateWithDuration:.3f delay:0.0f options:UIViewAnimationOptionTransitionNone
                         animations:^{
							 self.frame = frame;
                         }
                         completion:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    self.size = rect.size.width;
	CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:.4f green:.4f blue:1.0f alpha:.8f].CGColor);
    CGContextMoveToPoint(context, self.size/2, 0);
    CGContextAddLineToPoint(context, self.size/2, self.size);
    CGContextMoveToPoint(context, 0,self.size/2);
    CGContextAddLineToPoint(context, self.size, self.size/2);
    
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, self.size, self.size));
	CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:.0f green:.0f blue:1.0f alpha:.1f].CGColor);
    
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, self.size, self.size));
	CGContextFillPath(context);
    
    
}

@end
