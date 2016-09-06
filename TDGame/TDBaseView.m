//
//  TDBaseView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 26.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDBaseView.h"
#import "TDBase.h"

@implementation TDBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.countOfBounds = 5;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baseLoseHealth:) name:@"BaseLoseHealthNotification" object:nil];
    }
    return self;
}

-(void)baseLoseHealth:(NSNotification *)notification {
    TDBase *b = [notification object];
    if (b == self.cell) {
        self.countOfBounds = b.partOfHealth;
        [self setNeedsDisplay];
    }
}

- (void)drawBaseImage:(float)blockUnit andCountOfBounds:(int)countOfBounds
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.foregroundColor.CGColor);
    CGRect baseBounds[] = {
        CGRectMake(6.5*blockUnit, 6.5*blockUnit, 19*blockUnit, 19*blockUnit),
        CGRectMake(5*blockUnit, 5*blockUnit, 22*blockUnit, 22*blockUnit),
        CGRectMake(3.5*blockUnit, 3.5*blockUnit, 25*blockUnit, 25*blockUnit),
        CGRectMake(2*blockUnit, 2*blockUnit, 28*blockUnit, 28*blockUnit),
        CGRectMake(0.5*blockUnit, 0.5*blockUnit, 31*blockUnit, 31*blockUnit),
    };
    for (int i=0; i<countOfBounds; i++) {
        CGContextStrokeRectWithWidth(context, baseBounds[i], blockUnit);
    }
    CGContextSetLineWidth(context, 0.5*blockUnit);
    CGContextSetStrokeColorWithColor(context, self.foregroundColor.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(8*blockUnit, 8*blockUnit, 16*blockUnit, 16*blockUnit));
    CGContextStrokePath(context);
    
    CGPoint addLines[] =
	{
        CGPointMake(16*blockUnit, 8.5*blockUnit),
        CGPointMake(18.5*blockUnit, 13*blockUnit),
        CGPointMake(23.5*blockUnit, 13.5*blockUnit),
        CGPointMake(20*blockUnit, 17*blockUnit),
        CGPointMake(21*blockUnit, 22*blockUnit),
        CGPointMake(16*blockUnit, 19.5*blockUnit),
        CGPointMake(11*blockUnit, 22*blockUnit),
        CGPointMake(12*blockUnit, 17*blockUnit),
        CGPointMake(8.5*blockUnit, 13.5*blockUnit),
        CGPointMake(13.5*blockUnit, 13*blockUnit),
    };
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
    
    CGContextDrawPath(context, kCGPathFill);
}

- (void)drawRect:(CGRect)rect
{
    float u = rect.size.width / 32;
    
    [self drawBaseImage:u andCountOfBounds:self.countOfBounds];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
