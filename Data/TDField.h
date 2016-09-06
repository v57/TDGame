//
//  TDField.h
//  TDGame
//
//  Created by Сергей on 23.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDBase;
@class TDTower;
@class TDMob;

@interface TDField : NSObject
@property int width;
@property int height;
@property uint waveIndex;

@property (strong, nonatomic) NSArray *bases;
@property (strong, nonatomic) NSArray *spawners;
@property (strong, nonatomic) NSArray *road;
@property (strong, nonatomic) NSMutableArray *map;
@property (strong, nonatomic) NSMutableDictionary *mobs;
@property (strong, nonatomic) NSMutableArray *towers;
@property (strong, nonatomic) NSMutableDictionary *missiles;

@property (strong, nonatomic) TDMob *lastSpawnedMob;

@property float money;

@property NSTimeInterval currentTime;

- (id)initLevel:(int)numLevel;
- (void)updateByTime:(NSTimeInterval)timeInterval;
- (TDBase *)findBaseAtX:(int)x andY:(int)y;
- (TDTower *)findTowerAtX:(int)x andY:(int)y;
- (int)blockTypeAtX:(int)x andY:(int)y;
- (void)addTower:(NSString *)name atX:(int)x andY:(int)y;
- (void)addMoney:(float)money;
-(void)sellTower:(TDTower*)tower;

@end

