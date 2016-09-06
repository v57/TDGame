//
//  TDMob.h
//  TDGame
//
//  Created by Сергей on 27.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDCell.h"
#define PRECISION 0.001f
#define SHIFTDIRECTION 1.0f

@class TDField;

@interface TDMob : TDCell

@property int mobId;
//@property int groupId;
@property (strong, nonatomic) TDField *field;
@property (strong, nonatomic) NSString *name;
@property float hp;
@property float armor;
@property (nonatomic) float speed;
@property float uav;
@property float size;
@property BOOL fly;
@property float direction;
@property float nativeSpeed;
@property float initialOffsetX;
@property float initialOffsetY;

@property float vx;
@property float vy;
@property float distance;
@property int prevX;
@property int prevY;

@property BOOL goBack;

@property BOOL canBeFrozen;

@property BOOL visible;

@property BOOL haveBurn;
@property float burnTime;

@property TDMob *frontMob;
@property TDMob *behindMob;

@property float accuredHP;

@property NSMutableArray *effects;

// Поворот

@property BOOL canTurn;
@property int turnDirection;
@property float turnLeft;
@property float turnSpeed;


- (id)initWithName:(NSString *)name atX:(float)x andY:(float)y withOffsetX:(float)offsetX andOffsetY:(float)offsetY andDirection:(float)direction onField:(TDField *)field;
- (id)initWithName:(NSString *)name atX:(float)x andY:(float)y andDirection:(float)direction andFly:(BOOL)canFly andSpeed:(float)speed onField:(TDField *)field;
- (void)updateByTime:(NSTimeInterval)timeInterval;
- (void)receiveDamage:(float)hit;
- (void)receiveNoArmorDamage:(float)hit;
- (void)addEffect:(int)type:(float)strength;
- (BOOL)checkEffect:(int)type;
- (CGRect)getCollisionBox;

@end
