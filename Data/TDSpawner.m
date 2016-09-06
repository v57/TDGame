//
//  TDSpawner.m
//  TDGame
//
//  Created by Сергей on 23.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDSpawner.h"
#import "TDMob.h"
#import "TDField.h"

//static int staticGroupId;
static NSArray *mobInfo;
//static float prevGroupSpeed;

@implementation TDSpawner

- (void)updateByTime:(NSTimeInterval)time {
	if (!self.canStartNewWave && time >= self.newWaveSpawningTime) {
		self.canStartNewWave = YES;
	}
    if (time >= self.burnTime || self.burnTime-time < PRECISION) {
        [self nextGroupOfMobs:time];
    }
}

- (void)nextGroupOfMobs:(NSTimeInterval)time
{
    if ([self.mobWave count] == 0) {
		if (!self.canStartNewWave) {
			return;
		}
        [self newWave];
    }
    NSDictionary *mobAndCount = [self.mobWave objectAtIndex:0];
    uint mobCount = [[mobAndCount objectForKey:@"Count"] unsignedIntValue];
    NSString *mobName = [mobAndCount objectForKey:@"Name"];
    uint s = 0;
    uint r = 0;
    float distance = 1.0f;
    float speed = 2.5f; // 1.0f;
//    if (staticGroupId++ == 0) {
//        prevGroupSpeed = speed;
//    }
    if ([mobName isEqualToString:@"Soldier"]) {
        speed = 1.0f; //MIN(prevGroupSpeed, 1.0f);
        s = MIN(mobCount, 4);
        mobCount -= s;
        if (mobCount > 0) {
            [self.mobWave replaceObjectAtIndex:0 withObject:[NSDictionary dictionaryWithObjectsAndKeys:mobName, @"Name",  [NSNumber numberWithUnsignedInt:mobCount], @"Count", nil]];
        } else {
            [self.mobWave removeObjectAtIndex:0];
//            if ([self.mobWave count] < 1) {
//                [self newWave];
//            }
        }
        if (s<3 && [self.mobWave count]>0) {
            mobAndCount = [self.mobWave objectAtIndex:0];
            mobCount = [[mobAndCount objectForKey:@"Count"] unsignedIntValue];
            mobName = [mobAndCount objectForKey:@"Name"];
            if ([mobName isEqualToString:@"Rider"]) {
                r = 1;
                mobCount -= r;
                if (mobCount > 0) {
                    [self.mobWave replaceObjectAtIndex:0 withObject:[NSDictionary dictionaryWithObjectsAndKeys:mobName, @"Name",  [NSNumber numberWithUnsignedInt:mobCount], @"Count", nil]];
                } else {
                    [self.mobWave removeObjectAtIndex:0];
                }
            }
        }
    } else if ([mobName isEqualToString:@"Rider"]) {
        speed = 2.0f; // MIN(prevGroupSpeed, 2.0f);
        r = MIN(mobCount, 2);
        mobCount -= r;
        if (mobCount > 0) {
            [self.mobWave replaceObjectAtIndex:0 withObject:[NSDictionary dictionaryWithObjectsAndKeys:mobName, @"Name",  [NSNumber numberWithUnsignedInt:mobCount], @"Count", nil]];
        } else {
            [self.mobWave removeObjectAtIndex:0];
        }
        if (r==1 && [self.mobWave count]>0 && speed < 1.1f) {
            mobAndCount = [self.mobWave objectAtIndex:0];
            mobCount = [[mobAndCount objectForKey:@"Count"] unsignedIntValue];
            mobName = [mobAndCount objectForKey:@"Name"];
            if ([mobName isEqualToString:@"Soldier"]) {
                s = MIN(mobCount, 2);
                mobCount -= s;
                if (mobCount > 0) {
                    [self.mobWave replaceObjectAtIndex:0 withObject:[NSDictionary dictionaryWithObjectsAndKeys:mobName, @"Name",  [NSNumber numberWithUnsignedInt:mobCount], @"Count", nil]];
                } else {
                    [self.mobWave removeObjectAtIndex:0];
                }
            }
        }
    }
    
    if (s>0 || r>0) {
        TDMob *m;
        
        switch (r) {
            case 0:
                switch (s) {
                    case 1:
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.25f andOffsetY:0.25f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        break;
                        
                    case 2:
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.0f andOffsetY:0.25f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.5f andOffsetY:0.25f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        break;
                        
                    case 3:
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.0f andOffsetY:0.0f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.0f andOffsetY:0.5f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.5f andOffsetY:0.25f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        break;
                        
                    case 4:
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.0f andOffsetY:0.0f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.0f andOffsetY:0.5f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.5f andOffsetY:0.0f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.5f andOffsetY:0.5f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        break;
                        
                    default:
                        NSLog(@"ERROR WITH GROUPING!!! Soldiers=%d, Riders=%d", s, r);
                        break;
                }
                break;
                
            case 1:
                switch (s) {
                    case 0:
                        m = [[TDMob alloc] initWithName:@"Rider" atX:self.x andY:self.y withOffsetX:0.0f andOffsetY:0.0f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        break;
                        
                    case 1:
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.25f andOffsetY:0.0f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        m = [[TDMob alloc] initWithName:@"Rider" atX:self.x andY:self.y withOffsetX:0.0f andOffsetY:0.25f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        break;
                        
                    case 2:
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.0f andOffsetY:0.0f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        m = [[TDMob alloc] initWithName:@"Soldier" atX:self.x andY:self.y withOffsetX:0.5f andOffsetY:0.0f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        m = [[TDMob alloc] initWithName:@"Rider" atX:self.x andY:self.y withOffsetX:0.0f andOffsetY:0.25f andDirection:self.mobDirection onField:self.field];
                        m.speed = speed;
//                        m.groupId = staticGroupId;
                        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                        break;
                        
                    default:
                        NSLog(@"ERROR WITH GROUPING!!! Soldiers=%d, Riders=%d", s, r);
                        break;
                }
                break;
                
            case 2:
                if (s>0) {
                    NSLog(@"ERROR WITH GROUPING!!! Soldiers=%d, Riders=%d", s, r);
                } else {
                    m = [[TDMob alloc] initWithName:@"Rider" atX:self.x andY:self.y withOffsetX:0.0f andOffsetY:-0.25f andDirection:self.mobDirection onField:self.field];
                    m.speed = speed;
//                    m.groupId = staticGroupId;
                    [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                    m = [[TDMob alloc] initWithName:@"Rider" atX:self.x andY:self.y withOffsetX:0.0f andOffsetY:0.25f andDirection:self.mobDirection onField:self.field];
                    m.speed = speed;
//                    m.groupId = staticGroupId;
                    [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
                }
                break;
                
            default:
                NSLog(@"ERROR WITH GROUPING!!! Soldiers=%d, Riders=%d", s, r);
                break;
        }
//        prevGroupSpeed = speed;
    } else { // no multiunit groups
        float shiftX = 0.0f;
        float shiftY = 0.0f;
        if ([mobName isEqualToString:@"CP"] || [mobName isEqualToString:@"RC"] || [mobName isEqualToString:@"Bomber Plane"]) {
            shiftX = shiftY = -0.5f;
        }
        TDMob *m = [[TDMob alloc] initWithName:mobName atX:self.x andY:self.y withOffsetX:shiftX andOffsetY:shiftY andDirection:self.mobDirection onField:self.field];
        if (!m.fly) {
            speed = m.speed; // MIN(prevGroupSpeed, m.speed);
            m.speed = speed;
//            prevGroupSpeed = speed;
        } else {
            speed = m.speed;
        }
//        m.groupId = staticGroupId;
        if (m.size > 1.0f) {
            distance = m.size;
        }
        [self.field.mobs setObject:m forKey:[NSString stringWithFormat:@"%d", m.mobId]];
        if (--mobCount > 0) {
            [self.mobWave replaceObjectAtIndex:0 withObject:[NSDictionary dictionaryWithObjectsAndKeys:mobName, @"Name",  [NSNumber numberWithUnsignedInt:mobCount], @"Count", nil]];
        } else {
            [self.mobWave removeObjectAtIndex:0];
        }
    }
    
    self.burnTime += distance / speed;
	if ([self.mobWave count] == 0) {
		self.burnTime = self.newWaveSpawningTime = time + NEWWAVE_SPAWNING_INTERVAL;
		self.canStartNewWave = NO;
	}
}

- (void)newWave
{
/*
	[self.mobWave addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"StealthSoldier", @"Name",  [NSNumber numberWithUnsignedInt:10], @"Count", nil]];
	return;
*/
	uint uav = self.totalWAV + self.uavRemained;
    
    uint mobCount = (self.field.waveIndex + 1) / 2;
    if(mobCount >= [mobInfo count]) mobCount = [mobInfo count];
    
    NSMutableArray *mobInfoLimited = [[NSMutableArray alloc] initWithCapacity:mobCount];
    for (int i=0; i<mobCount; i++) {
        [mobInfoLimited addObject:[mobInfo objectAtIndex:i]];
    }
    NSSortDescriptor *speedDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Speed" ascending:NO];
    NSSortDescriptor *flyDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Fly" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObjects:flyDescriptor, speedDescriptor, nil];
    NSArray *mobInfoSorted = [mobInfoLimited sortedArrayUsingDescriptors:descriptors];
    
    float uavRemained = uav;
    uint mobCountRemained = mobCount;
    for (NSDictionary *mob in mobInfoSorted) {
        NSString *n = [mob objectForKey:@"Name"];
        float u = [[mob objectForKey:@"UAV"] floatValue];
        uint unitCount = uavRemained / mobCountRemained-- / u;
        if (unitCount < 1) {
            continue;
        }
        uavRemained -= unitCount*u;
        [self.mobWave addObject:[NSDictionary dictionaryWithObjectsAndKeys:n, @"Name",  [NSNumber numberWithUnsignedInt:unitCount], @"Count", nil]];
    }
    
    self.uavRemained = uavRemained;
    self.field.waveIndex++;
    self.totalWAV *= self.totalWAVMultiplier;
}

- (id)initWithX:(float)x andY:(float)y andDirection:(float)direction andWAV:(uint)wav andMultiplier:(float)multiplier onField:(TDField *)field
{
    self = [super initWithX:x andY:y];
    if (self) {
        self.mobDirection = direction;
        self.totalWAV = wav;
        self.totalWAVMultiplier = multiplier;
        self.field = field;
        
        self.burnTime = FIRST_SPAWNING;
        self.uavRemained = 0;
        
        self.mobWave = [NSMutableArray new];
		self.canStartNewWave = YES;
		self.newWaveSpawningTime = 0.0f;
        
        if (!mobInfo) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
            NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:path];
            mobInfo = [root objectForKey:@"Mobs"];
        }
    }
    return self;
}

- (void)dealloc
{
    self.field = nil;
    [self.mobWave removeAllObjects];
    self.mobWave = nil;
}

@end
