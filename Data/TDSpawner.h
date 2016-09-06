//
//  TDSpawner.h
//  TDGame
//
//  Created by Сергей on 23.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#define PRECISION			0.001f
#define FIRST_SPAWNING		1.0f
#define NEWWAVE_SPAWNING_INTERVAL	4.0f

#import "TDCell.h"
@class TDField;
@class TDMob;

@interface TDSpawner : TDCell
@property float mobDirection;
@property uint totalWAV;
@property float totalWAVMultiplier;
@property uint waveIndex;
@property uint uavRemained;
@property (strong, nonatomic) TDField *field;

@property NSTimeInterval burnTime;

@property NSMutableArray *mobWave;
@property BOOL canStartNewWave;
@property float newWaveSpawningTime;

- (id)initWithX:(float)x andY:(float)y andDirection:(float)direction andWAV:(uint)wav andMultiplier:(float)multiplier onField:(TDField *)field;
- (void)updateByTime:(NSTimeInterval)time;
@end
