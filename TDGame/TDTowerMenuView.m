//
//  TDTowerMenuView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 03.11.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDTowerMenuView.h"
#import "TDTower.h"
#import "TDTowerMenuButtonView.h"
@implementation TDTowerMenuView

- (id)initWithFrame:(CGRect)frame andTower:(TDTower*)tower andButtons:(TOWERMENUBUTTON)first:(TOWERMENUBUTTON)second:(TOWERMENUBUTTON)third
{
    self = [self initWithFrame:frame];
    self.owner = tower;
    float size = frame.size.width;
    float u = size/8;
    float s2 = u*4;
    float r = u*3/2;
    float b = u*1.5f;
    float b2 = b/2;

    float x1 = s2-cosf(M_PI/6) * r;
    float y1 = s2-sinf(M_PI/6) * r;
    float x2 = s2+cosf(M_PI/6) * r;
    float y2 = y1;
    float x3 = s2-cosf(M_PI_2) * r;
    float y3 = s2+sinf(M_PI_2) * r;
    if(first) self.first = [[TDTowerMenuButtonView alloc]initWithFrame:CGRectMake(x1-b2,y1-b2,b,b) andType:first];
    if(second) self.second = [[TDTowerMenuButtonView alloc]initWithFrame:CGRectMake(x2-b2,y2-b2,b,b) andType:second];
    if(third) self.third= [[TDTowerMenuButtonView alloc]initWithFrame:CGRectMake(x3-b2,y3-b2,b,b) andType:third];
    [self addSubview:self.first];
    [self addSubview:self.second];
    [self addSubview:self.third];
    
    
    return self; 
}
-(float)rotateButton:(int)n {
    TDTowerMenuButtonView*v;
    if(n == self.first.type) {
        v = self.first;
    }
    else if(n == self.second.type) {
        v = self.second;
    }
    else if(n == self.third.type) {
        v = self.third;
    }
    if(v) {
        v.angle = [self translateAngle4:++v.angle];
        float angle = v.angle;
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2*angle);
        [UIView animateWithDuration:.1f delay:0.0f options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             v.transform = transform;
                         }
                         completion:nil];
        return angle;
    }
    return 0;
    
}
-(float)translateAngle4:(float)a
{
    if(a>=4) {a-=4;}
    else if(a<=0) {a+=4;}
    return a;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0.0f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float u = rect.size.height/8;
	CGContextSetLineWidth(context, 2.0f);
    CGContextSetRGBStrokeColor(context, .0f, .0f, .0f, .7f);
    CGContextSetRGBFillColor(context, .0f, .0f, .0f, .5f);
    CGContextAddEllipseInRect(context, CGRectMake(u, u, 6*u, 6*u));
	CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context, cosf(M_PI_2) * u*3 + u*4, -sinf(M_PI_2) * u*3 + u*4);
    CGContextAddLineToPoint(context, u*4, u*4);
    
    CGContextMoveToPoint(context, cosf(M_PI/6) * u*3 + u*4, sinf(M_PI/6) * u*3 + u*4);
    CGContextAddLineToPoint(context, u*4, u*4);
    
    CGContextMoveToPoint(context, -cosf(M_PI/6) * u*3 + u*4, sinf(M_PI/6) * u*3 + u*4);
    CGContextAddLineToPoint(context, u*4, u*4);
    
	CGContextStrokePath(context);
    
}

- (void)dealloc
{
    self.owner = nil;
}

@end

















