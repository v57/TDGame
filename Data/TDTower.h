//
//  TDTower.h
//  TDGame
//
//  Created by Dmitry Kozlov on 18.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDCell.h"
@class TDField;
@class TDMob;

@interface TDTower : TDCell
@property (strong, nonatomic) TDField *field;
@property (strong, nonatomic) NSString *name;
@property float damage;
@property float attackSpeed;
@property float range;
@property float cost;
@property float upgradeCost;

@property uint level;
@property float nextShotTime;
@property float range2;
@property (strong, nonatomic) TDMob *target;
@property float targetDirection;

@property BOOL haveSplash;
@property BOOL haveAuraAttack;
@property BOOL secondTarget;

@property BOOL canReload;
@property BOOL coldEffect;
@property BOOL burnEffect;
@property BOOL radar;
@property float radiusEffect;
@property BOOL liquidEffect;
@property BOOL stunEffect;
@property float electricCharge;

@property BOOL airAttack;
@property BOOL groundAttack;

@property BOOL laser;
@property float laserDirection;

@property NSMutableArray *groupOfTowers;

- (id)initWithName:(NSString *)name atX:(float)x andY:(float)y onField:(TDField *)field;
- (void)updateByTime:(NSTimeInterval)timeInterval;
-(void)remove;
-(void)upgrade;
-(void)updateDirection;
@end
