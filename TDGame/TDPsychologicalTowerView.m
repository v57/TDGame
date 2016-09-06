//
//  TDPsychologicalTowerView.m
//  TDGame
//
//  Created by Сергей on 28.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDPsychologicalTowerView.h"

@implementation TDPsychologicalTowerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/*
- (void)drawStarWithRadius:(float)radius onContext:(CGContextRef)context
{
    float u = radius / 2;

    CGPoint addLines[] =
	{
		CGPointMake(0, -2*u), //
		CGPointMake(-0.449028*u, -0.618034*u),
		CGPointMake(-1.902113*u, -0.618034*u), //
		CGPointMake(-0.726543*u, 0.236068*u),
		CGPointMake(-1.175570*u, 1.618034*u), //
		CGPointMake(0, 0.763932*u),
		CGPointMake(1.175570*u, 1.618034*u), //
		CGPointMake(0.726543*u, 0.236068*u),
		CGPointMake(1.902113*u, -0.618034*u), //
		CGPointMake(0.449028*u, -0.618034*u),
	};
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextClosePath(context);
    
	CGContextStrokePath(context);
}
*/
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	float u = rect.size.width/16;
    
    [self drawBounds:rect];
    
    CGContextSetLineWidth(context, u/4);
    CGContextSetStrokeColorWithColor(context, self.foregroundColor.CGColor);
    
//    float R = 2*u;
//    float initRotateAngle = M_PI/5;
//    float initAngle = M_PI_2;
//    float r = 3.125*u;
//    float delta = M_PI * 0.4f;
//    for (int i=2; i<3; i++) {
//        float rotateAngle = initRotateAngle + i * delta;
//        float angle = initAngle + i * delta;
//        float x = 8*u + r*cosf(angle);
//        float y = 8*u - r*sin(angle);
//        CGContextConcatCTM(context, CGAffineTransformMakeTranslation(x, y));
//        CGContextConcatCTM(context, CGAffineTransformMakeRotation(-rotateAngle));
//        [self drawStarWithRadius:R onContext:context];
//    }
    
    CGPoint addLines[] =
	{
        CGPointMake(6.125*u, 5.5*u),
        CGPointMake(5.625*u, 6.75*u),
        CGPointMake(6.625*u, 7.5*u),
        CGPointMake(5.25*u, 7.5*u),
        CGPointMake(5*u, 9*u),
        CGPointMake(6.125*u, 10*u),
        CGPointMake(7.25*u, 9*u),
        CGPointMake(6.75*u, 10.375*u),
        CGPointMake(8*u, 11.25*u),
        CGPointMake(9.25*u, 10.375*u),
        CGPointMake(8.75*u, 9*u),
        CGPointMake(9.875*u, 10*u),
        CGPointMake(11*u, 9*u),
        CGPointMake(10.75*u, 7.5*u),
        CGPointMake(9.375*u, 7.5*u),
        CGPointMake(10.375*u, 6.75*u),
        CGPointMake(10.375*u, 6.75*u),
        CGPointMake(9.875*u, 5.5*u),
        CGPointMake(8.25*u, 5.5*u),
        CGPointMake(8*u, 6.75*u),
        CGPointMake(7.75*u, 5.5*u),
        CGPointMake(6.125*u, 5.5*u),
        
        CGPointMake(6.125*u, 5.5*u),
        CGPointMake(5*u, 6.375*u),
        CGPointMake(3.875*u, 5.5*u),
        CGPointMake(4.375*u, 6.75*u),
        CGPointMake(3.25*u, 7.5*u),
        CGPointMake(4.75*u, 7.5*u),
        CGPointMake(5*u, 9*u),
        CGPointMake(5.5*u, 10.375*u),
        CGPointMake(4.25*u, 11.25*u),
        CGPointMake(5.75*u, 11.25*u),
        CGPointMake(6.125*u, 12.5*u),
        CGPointMake(6.5*u, 11.25*u),
        CGPointMake(8*u, 11.25*u),
        CGPointMake(9.5*u, 11.25*u),
        CGPointMake(9.875*u, 12.5*u),
        CGPointMake(10.25*u, 11.25*u),
        CGPointMake(11.75*u, 11.25*u),
        CGPointMake(10.5*u, 10.375*u),
        CGPointMake(11*u, 9*u),
        CGPointMake(11.25*u, 7.5*u),
        CGPointMake(12.75*u, 7.5*u),
        CGPointMake(11.625*u, 6.75*u),
        CGPointMake(12.125*u, 5.5*u),
        CGPointMake(11*u, 6.375*u),
        CGPointMake(9.875*u, 5.5*u),
        CGPointMake(8.625*u, 4.75*u),
        CGPointMake(9.125*u, 3.375*u),
        CGPointMake(8*u, 4.25*u),
        CGPointMake(6.875*u, 3.375*u),
        CGPointMake(7.375*u, 4.75*u),
	};
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextClosePath(context);
    
	CGContextStrokePath(context);
}

@end
