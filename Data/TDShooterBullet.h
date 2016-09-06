//
//  TDShooterBullet.h
//  TDGame
//
//  Created by Dmitry Kozlov on 30.10.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDMob.h"
@class TDField;
@interface TDShooterBullet : TDMob
@property float direction;
@property TDMob *target;
@property float damage;
@property float splash;

- (id)initWithTarget:(TDMob*)target atX:(float)x andY:(float)y andSpeed:(float)speed andDamage:(float)damage andSplash:(float)splash onField:(TDField *)field;
- (void)updateByTime:(NSTimeInterval)timeInterval;
@end
