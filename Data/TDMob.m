//
//  TDMob.m
//  TDGame
//
//  Created by Сергей on 27.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDMob.h"
#import "TDField.h"
#import "TDBase.h"
#import "TDMap.h"
#import "TDEffect.h"

static int staticMobId;
static NSArray *mobs;
static TDBase *base;

@implementation TDMob

- (void)updateByTime:(NSTimeInterval)timeInterval {
    //checkEffects
    BOOL canMove = YES;
    float speedReduce = 1;
    float timeReduce = 1;
    float effectDamage = 0;
    if([self.effects count]) {
        BOOL r = NO;
        NSMutableArray* a;
        for(TDEffect *effect in self.effects) {
            if(!effect.firstTick) {
                effect.firstTick = YES;
                switch (effect.type) {
                    case VISIBLE:
                        self.visible = YES;
                        break;
                        
                    default:
                        break;
                }
            }
            switch (effect.type) {
                case FREEZE:
                    timeReduce = 0;
                    effectDamage += effect.strength * timeInterval;
                    break;
                    
                case COLD:
                    timeReduce -= effect.strength;
                    break;
                    
                case BURN:
                    effectDamage += effect.strength;
                    break;
                    
                case STUN:
                    speedReduce = 0;
                    break;
                    
                default:
                    break;
            }
            if(effect.aura) {effect.time -= 1;}
            else {effect.time -= timeInterval;}
            
            if(effect.time <= 0) {
                
                switch (effect.type) {
                    case VISIBLE:
                        self.visible = NO;
                        break;
                        
                    default:
                        break;
                }
                if(!r) {
                    a = [NSMutableArray new];
                    r = YES;
                }
                [a addObject:effect];
            }
        }
        if(r) {
            for(TDEffect *e in a) {
                [self removeEffect:e];
            }
        }
    }
    if(effectDamage) {[self receiveNoArmorDamage:effectDamage*timeInterval];}
    if(speedReduce < 0) {speedReduce = 0;}
    if(timeReduce  < 0) {timeReduce  = 0;}
    timeInterval *= timeReduce;
    if(timeInterval > 0) {
        
        //checkblock
        int ix = [self roundCoord:self.x forSpeed:self.vx];
        int iy = [self roundCoord:self.y forSpeed:self.vy];
        if (!self.fly) {
            if (ix != self.prevX || iy != self.prevY) {
                int blockType = [self.field blockTypeAtX:ix andY:iy];
                self.x = self.prevX = ix;
                self.y = self.prevY = iy;
                switch(blockType) {
                    case TURNRIGHT:
                        self.direction = 0;
                        self.vx = self.speed;
                        self.vy = 0;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"MobRotatedNotification" object:self];
                        break;
                        
                    case TURNUP:
                        self.direction = 1;
                        self.vx = 0;
                        self.vy = -self.speed;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"MobRotatedNotification" object:self];
                        break;
                        
                    case TURNLEFT:
                        self.direction = 2;
                        self.vx = -self.speed;
                        self.vy = 0;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"MobRotatedNotification" object:self];
                        break;
                        
                    case TURNDOWN:
                        self.direction = 3;
                        self.vx = 0;
                        self.vy = self.speed;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"MobRotatedNotification" object:self];
                        break;
                        
                    case BASE:
                        self.vx = self.vy = 0;
                        TDBase *b = [self.field findBaseAtX:ix andY:iy];
                        if (b) {
                            //NSLog(@"%@ [%d] landed %.0f hits on the Base.", self.name, self.mobId, self.hp);
                            [b receiveDamage:self.hp];
                        }
                         [self takeOffHP:self.hp];
                        break;
                }
            }
        }
        else {
            if (!base) {
                base = [self.field.bases objectAtIndex:0];
            }
            
            float dx = base.x + 0.5f - self.x;
            float dy = base.y + 0.5f - self.y;
            float directionToBase;
            
            if (dx == 0.0f) {
                directionToBase = (dy > 0.0f) ? 3.0f : 1.0f;
            } else {
                directionToBase = -atanf(dy / dx) / M_PI_2;
                if (dx < 0.0f) {
                    directionToBase += 2.0f;
                }
            }
            if (directionToBase < 0.0f) {
                directionToBase += 4.0f;
            }
            if (directionToBase >= 4.0f) {
                directionToBase -= 4.0f;
            }
            
            float delta = directionToBase - self.direction;
            if (delta <= -2.0f) {
                delta += 4.0f;
            }
            if (delta > 2.0f) {
                delta -= 4.0f;
            }
            
            float shiftDirection = SHIFTDIRECTION * timeInterval;
            if (ABS(delta) <= shiftDirection) {
                self.direction = directionToBase;
            } else {
                if (delta < 0.0f) {
                    shiftDirection = -shiftDirection;
                }
                self.direction += shiftDirection;
            }
            
            
            if (self.direction < 0.0f) {
                self.direction += 4.0f;
            }
            if (self.direction >= 4.0f) {
                self.direction -= 4.0f;
            }
            float rangle = self.direction * M_PI_2;
            self.vx = cosf(rangle) * self.speed;
            self.vy = -sinf(rangle) * self.speed;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MobRotatedNotification" object:self];
            
            if([self.field blockTypeAtX:ix andY:iy] == BASE) {
                self.vx = 0;
                self.vy = 0;
                TDBase *b = [self.field findBaseAtX:ix andY:iy];
                if (b) {
                    //NSLog(@"%@ [%d] landed %.0f hits on the Base.", self.name, self.mobId, self.hp);
                    [b receiveDamage:self.hp];
                }
                [self takeOffHP:self.hp];
            }
            
        }
        float speedCollision = timeInterval * speedReduce;
        /*
        if(self.canTurn) {
            int pm1 = self.turnDirection;
            self.direction += self.speed * speedCollision * pm1;
            
            self.turnLeft -= self.speed * speedCollision;
            if(self.turnLeft <= 0 ){
                self.canTurn = NO;
                //self.direction = roundf(self.direction);
            }
            [self correctDirection];
            if(self.mobId == 1) NSLog(@"[%.1f][%.1f][%.1f]",self.direction,self.x,self.y);
        }
         */
        
        if(!self.fly) {
			[self checkSpeed];
		}
        //move
        if(canMove) {
			self.x += self.vx * speedCollision;
			self.y += self.vy * speedCollision;
			if(!self.fly) {
				self.distance += self.speed * speedCollision;
			}
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MobMovedNotification" object:self];
    }
}

-(void)checkSpeed
{
	if (!self.frontMob || self.frontMob.hp <= 0.0f) {	// поиск ближайшего переднего моба self.frontMob
//		NSLog(@"Looking for front mob for %@ %d, %f", self.name, self.mobId, self.distance);
		TDMob *fm = nil;
		float fd = 10000.0f;
		for (TDMob *m in self.field.mobs.allValues) {
			if (!m.fly && m != self) {
//				NSLog(@"%@ %d, %f?", m.name, m.mobId, m.distance);
				float dist = m.distance - self.distance;
				if (dist>0.1f && dist<fd) {
					fd = dist;
					fm = m;
				}
			}
		}
		self.frontMob = fm;
		if (fm) {
			fm.behindMob = self;
		}
//		if (self.frontMob && [self.name isEqualToString:@"Soldier"] ) {
//			NSLog(@"Soldier %d -> %@ %d, %f", self.mobId, self.frontMob.name, self.frontMob.mobId, self.frontMob.distance - self.distance);
//		}
	}
		
	if (self.frontMob && self.speed > self.frontMob.speed && self.frontMob.distance-self.distance <= 1.0f) { // догнали переднего моба
		self.speed = self.frontMob.speed;
	}
}

/*
-(void)turn90:(float)dir
{
    //float oppositeAngle = [self translateAngle4:dir+2];
    int turnLeft = [self translateAngle4:dir-1];
    int turnRight = [self translateAngle4:dir+1];
    if((int)self.direction == turnLeft) {
        self.turnDirection = 1;
    }
    else if((int)self.direction == turnRight) {
        self.turnDirection = -1;
    }
    
    self.turnLeft = 1;
    self.canTurn = YES;
}

-(float)translateAngle4:(float)a
{
    if(a>=4) {a-=4;}
    else if(a<=0) {a+=4;}
    return a;
}
*/

- (int)roundCoord:(float)coord forSpeed:(float)v
{
    if (v >= 0) {
        return (int)(coord + PRECISION);
    } else {
        return ceil(coord - PRECISION);
    }
}

- (void)setSpeed:(float)speedValue
{
    _speed = speedValue;
    self.vx = self.speed * cosf(self.direction * M_PI_2);
    self.vy = -self.speed * sinf(self.direction * M_PI_2);
}

/*
-(void)correctDirection
{
    self.vx = self.speed * cosf(self.direction * M_PI_2);
    self.vy = -self.speed * sinf(self.direction * M_PI_2);
}
*/

- (void)receiveNoArmorDamage:(float)hit
{
    [self takeOffHP:hit];
}

- (void)receiveDamage:(float)hit
{
    if (hit < self.armor) {
        self.armor--;
    } else {
        [self takeOffHP:hit / self.armor];
    }
}

-(void)takeOffHP:(float)hp
{
    if(hp>self.hp){hp=self.hp;}
    self.hp-=hp;
    
    self.accuredHP += hp;
    [self.field addMoney:hp];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MobHittedNotification" object:self];
    if(self.accuredHP>=1) {
        self.accuredHP -= (int)self.accuredHP;
    }
    if (self.hp <= 0.0f) {
        if(self.behindMob && self.behindMob.hp>0) {
            self.behindMob.frontMob = nil;
        }
        self.hp = 0.0f;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MobDestroyedNotification" object:self];
    }
}

-(void)addEffect:(int)type:(float)strength
{
    TDEffect *effect = [[TDEffect alloc]initWithType:type andStrength:strength];
    TDEffect *liquid = [self getEffect:LIQUID];
    if(liquid) {
        effect.time *= 2;
        effect.strength *=2;
    }
    TDEffect *effect2 = [self getEffect:effect.type];
    if(effect2) {
        if(effect.strength > effect2.strength) {
            effect2.strength = effect.strength;
            effect2.time = effect.time;
        }
        else if(effect.strength == effect2.strength && effect.time > effect2.time) {
            effect2.time = effect.time;
        }
    }
    else {
        [self.effects addObject:effect];
    }
}

-(void)removeEffect:(TDEffect*)effect
{
    [self.effects removeObject:effect];
}

-(TDEffect*)getEffect:(int)type
{
    for(TDEffect*e in self.effects) {
        if(e.type == type) {
            return e;
        }
    }
    return nil;
}

-(BOOL)checkEffect:(int)type
{
    for(TDEffect*effect in self.effects) {
        if(effect.type == type) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)compareEffect:(TDEffect*)e1
{
    TDEffect *e2 = [self getEffect:e1.type];
    if(e2 != nil) {
        if(e1.strength > e2.strength) return YES;
        if(e1.strength < e2.strength) return NO;
        if(e1.time > e2.time) return YES;
        if(e1.time < e2.time) return NO;
    }
    return YES;
}

-(CGRect)getCollisionBox
{
    return CGRectMake(self.x+PRECISION,self.y+PRECISION,1+PRECISION*2,1+PRECISION*2);
    //return CGRectMake(self.x+PRECISION,self.y+PRECISION,self.width+PRECISION*2,self.height+PRECISION*2);
}

- (id)initWithName:(NSString *)name atX:(float)x andY:(float)y withOffsetX:(float)offsetX andOffsetY:(float)offsetY andDirection:(float)direction onField:(TDField *)field
{
    self = [super initWithX:x andY:y];
    if (self) {
        if (!mobs) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
            NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:path];
            mobs = [root objectForKey:@"Mobs"];
        }
        
        for (NSDictionary *m in mobs) {
            NSString *n = [m objectForKey:@"Name"];
            if ([n isEqualToString:name]) {
                self.field = field;
				self.mobId = ++staticMobId;
                self.name = name;
                self.fly = [[m objectForKey:@"Fly"] boolValue];
                self.hp = [[m objectForKey:@"Hp"] floatValue] * field.waveIndex;
                self.armor = [[m objectForKey:@"Armor"] floatValue];
                self.nativeSpeed = [[m objectForKey:@"Speed"] floatValue];
                self.uav = [[m objectForKey:@"UAV"] floatValue];
                self.size = [[m objectForKey:@"Size"] floatValue];
                self.width = [[m objectForKey:@"Width"] floatValue];
                self.height = [[m objectForKey:@"Height"] floatValue];
                self.visible = [[m objectForKey:@"Visible"] boolValue];
                self.canBeFrozen = [[m objectForKey:@"CanBeFrozen"] boolValue];
                self.direction = direction;
                self.offsetX = self.initialOffsetX = offsetX;
                self.offsetY = self.initialOffsetY = offsetY;
				self.distance = 0.0f;
                
                self.effects = [NSMutableArray new];
                
                self.speed = self.nativeSpeed;
                self.prevX = self.x;
                self.prevY = self.y;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewMobNotification" object:self];
                
                return self;
            }
        }
        NSLog(@"ERROR: No mobs with name=%@", name);
        return nil;
    }
    return self;
}

- (id)initWithName:(NSString *)name atX:(float)x andY:(float)y andDirection:(float)direction andFly:(BOOL)canFly andSpeed:(float)speed onField:(TDField *)field
{
    self = [super initWithX:x andY:y];
    if (self) {
        
		self.field = field;
		self.mobId = ++staticMobId;
		self.name = name;
		self.fly = canFly;
		self.hp = 0;
		self.armor = 0;
		if(!self.fly) {
			self.nativeSpeed = self.speed * field.waveIndex;
		}
		else {
			self.nativeSpeed = self.speed;
		}
		self.uav = 0;
		self.size = 1;
		self.width = 1;
		self.height = 1;
		self.visible = YES;
		self.canBeFrozen = NO;
		self.direction = direction;
		self.offsetX = self.initialOffsetX = 0;
		self.offsetY = self.initialOffsetY = 0;
		self.distance = 0.0f;
		
		self.effects = [NSMutableArray new];
		
		self.speed = self.nativeSpeed;
		self.prevX = self.x;
		self.prevY = self.y;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"NewMobNotification" object:self];
		
		return self;
	}
    return self;
}


- (void)dealloc
{
    self.name = nil;
    self.field = nil;
	self.behindMob = nil;
	self.frontMob = nil;
}

@end
