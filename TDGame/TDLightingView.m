//
//  TDLightingView.m
//  TDGame
//
//  Created by Dmitry Kozlov on 21.10.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDLightingView.h"
#import "TDCell.h"
#import "TDField.h"
#import "TDFieldView.h"
#import "TDTower.h"
#import "TDMob.h"
#include <stdlib.h>
@implementation TDLightingView

- (id)initWithCell:(float)tick:(TDTower *)tower:(TDMob *)mob onFieldView:(TDFieldView *)fieldView
{
    
    self.tower = tower;
    self.mob = mob;
    self.tick = tick;
    
    float blockSize = self.blockSize = fieldView.cellSize + fieldView.gridSize;
    float blockSize2 = blockSize/2;
    
    float x = tower.x * blockSize + blockSize2;
    float y = tower.y * blockSize + blockSize2;
    float width = mob.x * blockSize + blockSize2 - x;
    float height = mob.y * blockSize + blockSize2 - y;
    self = [self initWithFrame:CGRectStandardize(CGRectMake(x, y, width, height))];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    return self;
}

- (CGRect)receiveFrame
{
    float x = self.tower.x * self.blockSize + self.blockSize/2;
    float y = self.tower.y * self.blockSize + self.blockSize/2;
    float width = self.mob.x * self.blockSize + self.blockSize/2 - x;
    float height = self.mob.y * self.blockSize + self.blockSize/2 - y;
    return CGRectStandardize(CGRectMake(x, y, width, height));
}

- (void)drawRect:(CGRect)rect
{
    if (!self.tower.target || self.tower.target.hp <= 0 || ![self.mob isEqual:self.tower.target]) {
        self.tick = 0;
        return;
    }
    float mx = self.tower.target.x * self.blockSize;
    float my = self.tower.target.y * self.blockSize;
    float fx = self.tower.x * self.blockSize;
    float fy = self.tower.y * self.blockSize;
    
    float minX = MIN(mx,fx);
    float minY = MIN(my,fy);
    
    mx -= minX;
    fx -= minX;
    my -= minY;
    fy -= minY;
    CGRect r = [self receiveFrame];
    self.frame = r;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:.7f green:.7f blue:1.0f alpha:.9f].CGColor);
    CGContextMoveToPoint(context, fx,fy);
    CGContextAddLineToPoint(context, mx, my);
	CGContextStrokePath(context);
}

- (float)mod:(float)a
{
	if(a<0) return -a;
	else return a;
}

- (float)getDistance:(float)x1:(float)y1:(float)x2:(float)y2
{
	float dx = x1 - x2;
    float dy = y1 - y2;
    return sqrtf(dx*dx + dy*dy);
}

- (float)getAngle:(float)x1:(float)y1:(float)x2:(float)y2
{
	float dx = x1 - x2;
	float dy = -(y1 - y2);
	float dist = [self getDistance:x2:y2:x1:y1];
	float x = dx/dist;
	float y = dy/dist;
	float angle = acosf(x);
	if(y<0) {angle = -angle;}
	return angle;
}

- (void)dealloc
{
    self.tower = nil;
    self.mob = nil;
}

@end
