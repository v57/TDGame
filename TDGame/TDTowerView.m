//
//  TDTowerView.m
//  TDGame
//
//  Created by Сергей on 22.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDTowerView.h"
#import "TDTower.h"

@implementation TDTowerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(directionChanged:) name:@"TowerDirectionChangedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTower:) name:@"RemoveTowerNotification" object:nil];
    }
    return self;
}

- (void)directionChanged:(NSNotification *)notification
{
    if ([notification object] == self.cell) {
        [self setNeedsDisplay];
    }
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

- (void)drawBounds:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    float u = rect.size.width/16;
    CGContextSetStrokeColorWithColor(context, self.foregroundColor.CGColor);
	CGContextSetLineWidth(context, u);
    [self drawRoundRect:CGRectMake(0.5*u, 0.5*u, 15*u, 15*u) withRadius:2.5*u];
    [self drawRoundRect:CGRectMake(2*u, 2*u, 12*u, 12*u) withRadius:u];
}

- (void)rotateTower:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    float angle = ((TDTower *)self.cell).targetDirection;
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(rect.size.width/2.0f, rect.size.height/2.0f));
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(-angle));
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-rect.size.width/2.0f, -rect.size.height/2.0f));
}

- (id)initWithTower:(TDTower *)tower onFieldView:(TDFieldView *)fieldView
{
    self = [super initWithCell:tower onFieldView:fieldView];
    return self;
}
- (void)removeTower:(NSNotification*)notification
{
    if ([notification object] == self.cell) {
        [self removeFromSuperview];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
