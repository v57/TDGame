//
//  TDShooterBullet.m
//  TDGame
//
//  Created by Dmitry Kozlov on 30.10.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDShooterBullet.h"
#import "TDMob.h"
#import "TDField.h"

@implementation TDShooterBullet

- (void)mobDestroyed:(NSNotification *)notification
{
	TDMob *m = [notification object];
    if (m.mobId == self.target.mobId) {
        //NSLog(@"Target %d destroyed, so Missile %d expoloses", m.mobId, self.mobId);
        [self explode];
    }
}

- (void)updateByTime:(NSTimeInterval)timeInterval
{
    if(!self.target || self.target.hp <= 0) {
        return;
    }
    [self followTarget];
    self.x += self.vx *timeInterval;
    self.y += self.vy *timeInterval;
    if([self checkDistanceFor:self.target.x and:self.target.y by:self.speed * timeInterval]) {
        [self.target receiveDamage:self.damage];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MissileDestroyedNotification" object:self];
    }
	else {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MobMovedNotification" object:self];
	}
}

-(void)explode
{
    for(TDMob *m in self.field.mobs.allValues) {
        if([self checkDistanceFor:m.x and:m.y by:self.splash]) {
            [m receiveDamage:3.0f];
        }
    }
	[[NSNotificationCenter defaultCenter] postNotificationName:@"MissileDestroyedNotification" object:self];
}

- (id)initWithTarget:(TDMob*)target atX:(float)x andY:(float)y andSpeed:(float)speed andDamage:(float)damage andSplash:(float)splash onField:(TDField *)field
{
    self = [super initWithName:@"Missile" atX:x andY:y withOffsetX:0.0f andOffsetY:0.0f andDirection:0.0f onField:(TDField *)field];
    if (self) {
        self.target = target;
        self.speed = speed;
        self.damage = damage;
        self.splash = splash;
        self.field = field;
        [self followTarget];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewMobNotification" object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mobDestroyed:) name:@"MobDestroyedNotification" object:nil];
        //NSLog(@"Missile %d have launched for target %d", self.mobId, target.mobId);
    }
    return self;
}

- (void)followTarget
{
    if (self.target) {
        float dx = self.target.x - self.x;
        float dy = self.target.y - self.y;
        self.direction = atan2f(-dy, dx);
        self.vx = self.speed * cosf(self.direction);
        self.vy = - self.speed * sinf(self.direction);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MobRotatedNotification" object:self];
    }
}

- (BOOL)checkDistanceFor:(float)x and:(float)y by:(float)dist
{
    float dx = self.x - x;
    float dy = self.y - y;
    return (dx*dx + dy*dy < dist*dist);
}

- (void)dealloc
{
    //NSLog(@"Missile %d deallocated", self.mobId);
    self.target = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
