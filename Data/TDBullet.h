//
//  TDBullet.h
//  TDGame
//
//  Created by Dmitry Kozlov on 30.10.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//


#define LASERTIME .5f
#define SPLASH 3.0f
#define LINESPEED 7.0f

#import "TDCell.h"
#import "TDMob.h"
#import "TDTower.h"


typedef enum
{
	LINE = 0,
	LASER,
	MISSILE,
} BULLET;

@class TDField;

@interface TDBullet : TDCell

@property float damage;
@property (strong, nonatomic) TDTower *owner;
@property (strong, nonatomic) TDMob *target;
@property uint type;

//LINE
@property float vx;
@property float vy;
@property float speed;
@property float time;


- (id)initWithTarget:(TDMob*)target atX:(float)x andY:(float)y andOwner:(TDTower*)tower;
- (void)updateByTime:(NSTimeInterval)timeInterval;


@end
