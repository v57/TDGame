//
//  TDTower.m
//  TDGame
//
//  Created by Dmitry Kozlov on 18.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDTower.h"
#import "TDField.h"
#import "TDMob.h"
#import "TDMissile.h"
#import "TDEffect.h"
#import "TDBullet.h"

#define DAMAGEMULTIPLIER 2.0f
#define COSTMULTIPLIER 2.0f

static NSArray *towers;

@implementation TDTower

- (void)updateByTime:(NSTimeInterval)timeInterval {
    if(self.canReload) {
		self.nextShotTime -= timeInterval;
		[self followTarget];
		if ([self.name isEqualToString:@"ElectricTower"]) {
            self.damage += 5*timeInterval;
            if (self.damage >= 30.0f) {
                self.damage = 30.0f;
            }
		}
		if (self.target && self.nextShotTime <= 0.0f) {
			if ([self.name isEqualToString:@"ElectricTower"]) {
                if(self.electricCharge == 0.0f) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LightingNotification" object:self];
                }
                self.electricCharge += timeInterval;
                if (self.electricCharge <= 0.5f) {
                    float damage = self.damage;
                    if([self.target checkEffect:LIQUID]) {
                        damage *= 2;
                    }
                    [self.target receiveNoArmorDamage:2*damage*timeInterval];
                }
                else {
                    self.damage = 5;
                    self.electricCharge = 0.0f;
                    [self reload];
                }
			}
			else if ([self.name isEqualToString:@"MissileTower"]) {
				TDMissile *m = [[TDMissile alloc] initWithTarget:self.target atX:self.x andY:self.y andSpeed:7.0f andDamage:self.damage andSplash:3.0f onField:self.field];
				[self.field.missiles setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
				[self reload];
			}
			else if(self.haveSplash) {
                [self shotAtTarget:self.target];
				[self splashAttack];
			}
			else if(self.haveAuraAttack) {
				[self auraAttack];
			}
			else if(self.secondTarget) {
				[self shotAtTarget:self.target];
				[self shotAtSecondTarget];
			}
			else {
				[self shotAtTarget:self.target];
				if(self.burnEffect) {
					[self findTarget];
				}
			}
		}
    }
    else {
        if(self.radar) {
            for(TDMob *m in [self.field.mobs allValues]) {
                if((!m.visible || [m checkEffect:VISIBLE]) && [self checkDistanceFor:self.x and:self.y with:m.x and:m.y by:self.range2]) {
                    [m addEffect:VISIBLE:0];
                }
            }
        }
        else if(self.laser) {
            float damage = self.damage * timeInterval;
            CGRect hitBox = CGRectMake(0,0,0,0);
            float correct = PRECISION-0.5f;
            if(self.laserDirection==0) {
                hitBox = CGRectMake(self.x,self.y+correct,self.field.width,self.height);
            }
            else if(self.laserDirection==1) {
                hitBox = CGRectMake(self.x+correct,self.y,self.width,self.field.height);
            }
            else if(self.laserDirection==2) {
                hitBox = CGRectMake(0,self.y+correct,self.x,self.height);
            }
            else if(self.laserDirection==3) {
                hitBox = CGRectMake(self.x+correct,0,self.width,self.y);
            }
            for(TDMob *m in [self.field.mobs allValues]) {
                CGPoint pos = CGPointMake(m.x,m.y);
                if(CGRectContainsPoint(hitBox, pos)) {[m receiveNoArmorDamage:damage];}
            }
        }
    }
    
    
    
}
-(void)updateDirection {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TowerDirectionChangedNotification" object:self];
}

-(BOOL)inrange:(float)n1:(float)n2:(float)range
{
    if(n1 >= n2 - range/2 && n1 <= n2 + range/2) {
        return YES;
    }
    else return NO;
}

- (void)followTarget
{
    if (!self.target || self.target.hp <= 0 || !self.target.visible || ![self checkDistanceFor:self.x and:self.y with:self.target.x and:self.target.y by:self.range2]) {
        [self findTarget];
        if ([self.name isEqualToString:@"ElectricTower"]) {[self reload];}
    }
    if (self.target) {
        float dx = self.target.x - self.x;
        float dy = self.target.y - self.y;
        self.targetDirection = atan2f(-dy, dx);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TowerDirectionChangedNotification" object:self];
    }
}

- (void)shotAtTarget:(TDMob*)m
{
    [self reload];
    float damage = self.damage;
    if(self.coldEffect) {
        if(m.canBeFrozen) {
            [m addEffect:FREEZE:self.level];
        } else {
            [m addEffect:COLD:self.level];
        }
    }
    if(self.burnEffect) {
        [m addEffect:BURN:self.damage];
    }
    if(self.liquidEffect) {
        [m addEffect:LIQUID:self.level];
    }
    if(self.haveSplash) {
        damage /= 2;
    }
    [m receiveDamage:damage];
    if(m.hp <= 0.0f) {
        [self findTarget];
    }
}

- (void)findTarget
{
    self.target = nil;
    for (TDMob *m in [self.field.mobs allValues]) {
            if((self.airAttack && m.fly) || (!self.airAttack && !m.fly)) {
                if (m.hp > 0.0f && [self checkDistanceFor:self.x and:self.y with:m.x and:m.y by:self.range2]) {
                    if([self.name isEqualToString:@"Radar"]) {
                        if(!m.visible) {
                            [m addEffect:VISIBLE :0];
                        }
                    }
                    else {
                        if(m.visible) {
                            if(self.burnEffect) {
                                if(![m checkEffect:BURN]) {
                                    self.target = m;
                                }
                            }
                            else {
                                self.target = m;
                                return;
                            }
                        }
                    }
                }
            }
        }
}

-(void)findAnotherTarget
{
    uint mobID = self.target.mobId;
    
    for (TDMob *m in [self.field.mobs allValues]) {
        if(m.visible) {
            if((self.airAttack && m.fly) || (!self.airAttack && !m.fly)) {
                if(m.mobId != mobID) {
                    if (m.hp > 0.0f && [self checkDistanceFor:self.x and:self.y with:m.x and:m.y by:self.range2]) {
                        self.target = m;
                        return;
                    }
                }
            }
        }
    }
}

-(void)reload
{
    self.nextShotTime = 60.0f / self.attackSpeed;
    if(self.electricCharge) {self.electricCharge = 0;}
}

-(void)shotAtSecondTarget
{
    TDMob *m = self.target;
    [self findAnotherTarget];
    [self shotAtTarget:self.target];
    self.target = m;
}

-(void)auraAttack
{
    [self reload];
    for(TDMob *m in [self.field.mobs allValues]) {
        if([self checkDistanceFor:self.x and:self.y with:m.x and:m.y by:self.range2]) {
            [m receiveDamage:self.damage];
            [m addEffect:STUN:0];
        }
    }
}

-(void)splashAttack
{
    for(TDMob *m in [self.field.mobs allValues]) {
        if ([self checkDistanceFor:self.target.x and:self.target.y with:m.x and:m.y by:0.25f]) {
            if (self.target.mobId != m.mobId) {
				[m receiveDamage:self.damage/2];
			}
        }
    }
}

- (BOOL)checkDistanceFor:(float)x1 and:(float)y1 with:(float)x2 and:(float)y2 by:(float)dist
{
    if (self.range < 0) {
        return YES;
    }
    float dx = x1 - x2;
    float dy = y1 - y2;
    return (dx*dx + dy*dy < dist);
}

- (void)radarr
{
    for(TDTower *t in self.field.towers) {
        if([self checkDistanceFor:t.x and:t.y with:self.x and:self.y by:self.range2] && ![t.name isEqualToString:@"Radar"] && self.radiusEffect > t.radiusEffect) {
            t.radiusEffect = self.radiusEffect;
        }
    }
}

- (void)remove
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveTowerNotification" object:self];
}

-(void)upgrade {
    self.level ++;
    
    self.cost += self.upgradeCost;
    self.upgradeCost *= COSTMULTIPLIER;
    self.damage *= DAMAGEMULTIPLIER;
    
    NSLog(@"[Level:%d][Upgrade cost:%d][Damage:%f]",self.level,(int)self.upgradeCost,self.damage);
}

- (id)initWithName:(NSString *)name atX:(float)x andY:(float)y onField:(TDField *)field
{
    self = [super initWithX:x andY:y];
    if (self) {
        if (!towers) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
            NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:path];
            towers = [root objectForKey:@"Towers"];
        }
        
        for (NSDictionary *t in towers) {
            NSString *n = [t objectForKey:@"Name"];
            if ([n isEqualToString:name]) {
                self.field = field;
                self.name = name;
                self.damage = [[t objectForKey:@"Damage"] floatValue];
                self.attackSpeed = [[t objectForKey:@"AttackSpeed"] floatValue];
                self.range = [[t objectForKey:@"Range"] floatValue]+1;
                self.cost = [[t objectForKey:@"Cost"] floatValue];
                self.upgradeCost = self.cost*1.5f;
                self.level = 1;
                
                self.airAttack = [[t objectForKey:@"AntiAir"] boolValue];
                self.canReload = [[t objectForKey:@"CanReload"] boolValue];
                
                self.nextShotTime = 60.0f / self.attackSpeed;
                self.range2 = self.range * self.range;
                
                if ([self.name isEqualToString:@"BomberTower"]) {
					self.haveSplash = YES;
				}
                else if ([self.name isEqualToString:@"FreezeTower"]) {
					self.coldEffect = YES;
				}
                else if ([self.name isEqualToString:@"FireTower"]) {
					self.burnEffect = YES;
				}
                else if ([self.name isEqualToString:@"LiquidTower"]) {
					self.liquidEffect = YES;
				}
                else if ([self.name isEqualToString:@"ElectricTower"]) {
                    
                }
                else if([self.name isEqualToString:@"ShockTower"]) {
                    self.haveAuraAttack = YES;
                    self.stunEffect = YES;
                }
                else if ([n isEqualToString:@"ArtilleryTower"]) {
                    self.width = 2.0f;
                }
                else if([n isEqualToString:@"AATower"]) {
                    self.secondTarget = YES;
                }
                else if([n isEqualToString:@"Radar"]) {
                    self.radar = YES;
                    [self radarr];
                }
                else if([n isEqualToString:@"LaserTower"]) {
                    self.laser = YES;
                    self.laserDirection = 0;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTowerNotification" object:self];
                return self;
            }
        }
        NSLog(@"ERROR: No towers with name=%@", name);
        return nil;
    }
    return self;
}

- (void)dealloc
{
    self.field = nil;
    self.name = nil;
    self.target = nil;
}

@end
