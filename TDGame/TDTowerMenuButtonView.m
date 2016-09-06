//
//  TDTowerMenuButtonView.m
//  TDGame
//
//  Created by Дмитрий on 02.12.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDTowerMenuButtonView.h"
#import "TDTowerMenuView.h"

@implementation TDTowerMenuButtonView

-(id)initWithFrame:(CGRect)frame andType:(int)type {
    self = [self initWithFrame:frame];
    self.type = type;
    self.backgroundColor = [UIColor clearColor];
    self.angle = 0;
    return self;
}

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
    float u = rect.size.height/16;
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:.8f green:.8f blue:.8f alpha:1.0f].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:.8f green:.8f blue:.8f alpha:1.0f].CGColor);
    
    switch (self.type) {
        case UPGRADEBUTTON:
            CGContextSetLineWidth(context, 2);
            
            CGPoint addLines[] =
        {
            CGPointMake(8*u, 0*u),
            CGPointMake(14*u, 10*u),
            CGPointMake(10*u, 10*u),
            CGPointMake(10*u, 16*u),
            CGPointMake(6*u, 16*u),
            CGPointMake(6*u, 10*u),
            CGPointMake(2*u, 10*u),
        };
            CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
            
            CGContextFillPath(context);

            
            break;
            
        case SELLBUTTON:
            CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f].CGColor);
            float lw = u*2;
            float lw2 = lw/2;
            CGContextSetLineWidth(context, lw);
            CGContextSetLineJoin(context,kCGLineJoinRound);
            
            
            CGPoint dollarLines[] =
        {
            CGPointMake(14*u+lw2, 2*u),
            CGPointMake(2*u, 2*u),
            CGPointMake(2*u, 8*u),
            CGPointMake(14*u, 8*u),
            CGPointMake(14*u, 14*u),
            CGPointMake(2*u-lw2, 14*u),
        };
            CGContextAddLines(context, dollarLines, sizeof(dollarLines)/sizeof(dollarLines[0]));
            
            CGContextStrokePath(context);
            
            CGContextMoveToPoint(context, 6*u,0);
            CGContextAddLineToPoint(context, 6*u,16*u);
            
            CGContextMoveToPoint(context, 10*u,0);
            CGContextAddLineToPoint(context, 10*u,16*u);
            
            CGContextStrokePath(context);
            
            break;
            
        case TACTICBUTTON:
            CGContextSetLineWidth(context, u);
            
            CGContextAddEllipseInRect(context, CGRectMake(2*u, 2*u, 12.0f*u, 12.0f*u));
            CGContextMoveToPoint(context, 8*u, 0);
            CGContextAddLineToPoint(context, 8*u, 4*u);
            
            CGContextMoveToPoint(context, 0,8*u);
            CGContextAddLineToPoint(context, 4*u,8*u);
            
            CGContextMoveToPoint(context, 12*u,8*u);
            CGContextAddLineToPoint(context, 16*u,8*u);
            
            CGContextMoveToPoint(context, 8*u,12*u);
            CGContextAddLineToPoint(context, 8*u,16*u);
            CGContextStrokePath(context);
            
            CGContextAddEllipseInRect(context, CGRectMake(7*u, 7*u, 2*u, 2*u));
            
            CGContextFillPath(context);
            
            break;
        case DIRECTIONBUTTON:
            CGContextSetLineWidth(context, 2);
            
            CGPoint directionLines[] =
        {
            
            CGPointMake(16*u, 8*u),
            CGPointMake(6*u, 14*u),
            CGPointMake(6*u, 10*u),
            CGPointMake(0, 10*u),
            CGPointMake(0, 6*u),
            CGPointMake(6*u, 6*u),
            CGPointMake(6*u, 2*u)
        };
            CGContextAddLines(context, directionLines, sizeof(directionLines)/sizeof(directionLines[0]));
            
            CGContextFillPath(context);
            
            break;
            
        default:
            break;
    }
}


@end
