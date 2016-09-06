//
//  TDMobView.m
//  TDGame
//
//  Created by Сергей on 22.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDMobView.h"
#import "TDMob.h"
#import "TDEffect.h"

@implementation TDMobView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self rotateMobView];
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             self.alpha = 1.0f;
                         }
                         completion:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveMob:) name:@"MobMovedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateMob:) name:@"MobRotatedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroyMob:) name:@"MobDestroyedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroyMob:) name:@"MissileDestroyedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hitMob:) name:@"MobHittedNotification" object:nil];
    }
    return self;
}

- (id)initWithMob:(TDMob *)mob onFieldView:(TDFieldView *)fieldView
{
    self = [super initWithCell:mob onFieldView:fieldView];
    return self;
}

- (void)moveMob:(NSNotification *)notification
{
    TDMob *m = [notification object];
    if (m == self.cell) {
        [self placeCell];
        UIColor *color = [UIColor blackColor];
        
        if ([m checkEffect:BURN]) {
            color = [UIColor redColor];
        }
        else if([m checkEffect:COLD]) {
            color = [UIColor blueColor];
        }
        else if([m checkEffect:FREEZE]) {
            color = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1];
        }
        else if([m checkEffect:LIQUID]) {
            color = [UIColor colorWithRed:0.5 green:0.5 blue:.5f alpha:1];
        }
        else if(!m.visible) {
            color = [UIColor lightGrayColor];
        }
        if(self.foregroundColor != color) {
            self.foregroundColor = color;
            [self setNeedsDisplay];
        }
    }
}

- (void)rotateMob:(NSNotification *)notification
{
    if ([notification object] == self.cell) {
        [self rotateMobView];
        [self setNeedsDisplay];
    }
}

- (void)hitMob:(NSNotification *)notification
{
    TDMob *m = [notification object];
    if (m == self.cell) {
        self.alpha = 0.4f;
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionTransitionNone
                         animations:^{
							 self.alpha = 1.0f;
                         }
                         completion:nil];
    }
}

- (void)destroyMob:(NSNotification*)notification
{
    if ([notification object] == self.cell) {
        [self removeFromSuperview];
    }
}

- (void)rotateMobView
{
    CGAffineTransform tShift = CGAffineTransformMakeTranslation(self.cell.width / 2.0f - 0.5f, self.cell.height / 2.0f - 0.5f);
    CGAffineTransform tRotate = CGAffineTransformMakeRotation(-((TDMob*)self.cell).direction * M_PI_2);
    CGAffineTransform t = CGAffineTransformConcat(CGAffineTransformConcat(tShift, tRotate), CGAffineTransformInvert(tShift));
    
    CGPoint pShift = CGPointApplyAffineTransform(CGPointMake(((TDMob *)self.cell).initialOffsetX, ((TDMob *)self.cell).initialOffsetY), t);
    
    self.cell.offsetX = pShift.x;
    self.cell.offsetY = pShift.y;
}

- (void)rotateDrawContext:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(rect.size.width/2.0f, rect.size.height/2.0f));
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(-((TDMob*)self.cell).direction * M_PI_2));
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-rect.size.width/2.0f, -rect.size.height/2.0f));
}
/*
- (void)drawBounds
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect rect = self.frame;
	
    float u = rect.size.width/16;
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
	CGContextSetLineWidth(context, u);
	CGContextAddRect(context, CGRectMake(u/2, u/2, 15*u, 15*u));
	CGContextStrokePath(context);
}
*/
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
