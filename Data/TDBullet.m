//
//  TDBullet.m
//  TDGame
//
//  Created by Dmitry Kozlov on 30.10.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDBullet.h"
#import "TDMob.h"
#import "TDField.h"

@implementation TDBullet
- (void)updateByTime:(NSTimeInterval)timeInterval
{
    
}

-(BOOL)checkMob:(TDMob*)mob {
    return mob && mob.hp>0;
}

- (id)initWithTarget:(TDMob*)target atX:(float)x andY:(float)y andOwner:(TDTower*)tower
{
    
    if (self) {
        self.x = x;
        self.y = y;
        self.target = target;
        if(self.type == LINE) {
            float dx = x - target.x;
            float dy = y - target.y;
            float distance = dx*dx + dy*dy;
            float speed2 = LINESPEED*LINESPEED;
            self.time = distance / speed2;
        }
        else if(self.type == LASER) {
            
        }
        else if(self.type == MISSILE) {
            
        }
    }
    return self;
}

- (void)dealloc
{
    //NSLog(@"Missile %d deallocated", self.mobId);
    self.owner = nil;
    self.target = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
