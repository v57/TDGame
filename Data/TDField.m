//
//  TDField.m
//  TDGame
//
//  Created by Сергей on 23.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDField.h"
#import "TDBase.h"
#import "TDSpawner.h"
#import "TDRoad.h"
#import "TDMob.h"
#import "TDTower.h"
#import "TDMissile.h"
#import "TDMap.h"

static NSArray *levels;
static int destroyedMobId;

@implementation TDField

- (void)mobDestroyed:(NSNotification *)notification
{
	TDMob *m = [notification object];
    if (m.mobId != destroyedMobId) {
        [self.mobs removeObjectForKey:[NSString stringWithFormat:@"%d", m.mobId]];
        destroyedMobId = m.mobId;
    }
}

- (void)missileDestroyed:(NSNotification *)notification
{
	TDMissile *m = [notification object];
    if (m.mobId != destroyedMobId) {
        [self.missiles removeObjectForKey:[NSString stringWithFormat:@"%d", m.mobId]];
        destroyedMobId = m.mobId;
    }
}

-(void)removeTower:(TDTower*)tower
{
    [self changeBlockType:EMPTY:tower.x:tower.y];
    [tower remove];
    [self.towers removeObject:tower];
}

-(void)sellTower:(TDTower*)tower
{
    [self addMoney:tower.cost*0.75f];
    [self removeTower:tower];
}

- (void)updateByTime:(NSTimeInterval)timeInterval
{
    for (TDSpawner *s in self.spawners) {
        [s updateByTime:self.currentTime];
    }
    
    for (TDMob *m in self.mobs.allValues) {
        [m updateByTime:timeInterval];
    }
    
    for (TDTower *t in self.towers) {
        [t updateByTime:timeInterval];
    }
    
    for (TDMissile *r in self.missiles.allValues) {
        [r updateByTime:timeInterval];
    }
    
    self.currentTime += timeInterval;
}

- (id)initLevel:(int)numLevel
{
    self = [super init];
    if (self) {
        if (!levels) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
            NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:path];
            levels = [root objectForKey:@"Levels"];
        }
        
        if (numLevel<0 || numLevel>=[levels count]) {
            NSLog(@"ERROR: level=%d, total count of levels in data file: %d", numLevel, [levels count]);
            return nil;
        }
                
        NSDictionary *level = [levels objectAtIndex:numLevel];
        self.width = [[level objectForKey:@"Width"] integerValue];
        self.height = [[level objectForKey:@"Height"] integerValue];
        self.money = [[level objectForKey:@"Money"] floatValue];
        self.waveIndex = 1;
        
        self.map = [[NSMutableArray alloc] initWithCapacity:self.width];
        for(int i=0; i<self.width; i++) {
            NSMutableArray *mapY = [[NSMutableArray alloc] initWithCapacity:self.height];
            for(int j=0; j<self.height; j++) {
                TDMap *m = [TDMap new];
                m.type = EMPTY;
                [mapY addObject:m];
            }
            [self.map addObject:mapY];
        }
        
        self.mobs = [NSMutableDictionary new];
        self.towers = [NSMutableArray new];
        self.missiles = [NSMutableDictionary new];
        self.currentTime = 0;
        
        NSArray *bases = [level objectForKey:@"Bases"];
        NSMutableArray *baseArray = [NSMutableArray new];
        for (NSDictionary *base in bases) {
            float x = [[base objectForKey:@"X"] floatValue];
            float y = [[base objectForKey:@"Y"] floatValue];
            float health = [[base objectForKey:@"Health"] floatValue];
            TDBase *b = [[TDBase alloc] initWithX:x andY:y andHealth:health];
            [baseArray addObject:b];
            [self changeBlockType:BASE:x:y];
            [self changeBlockType:BASE:x+1:y];
            [self changeBlockType:BASE:x:y+1];
            [self changeBlockType:BASE:x+1:y+1];
        }
        self.bases = baseArray;
        
        NSArray *spawners = [level objectForKey:@"Spawners"];
        NSMutableArray *spawnerArray = [NSMutableArray new];
        for (NSDictionary *spawner in spawners) {
            float x = [[spawner objectForKey:@"X"] floatValue];
            float y = [[spawner objectForKey:@"Y"] floatValue];
            float dir = [[spawner objectForKey:@"Direction"] floatValue];
            TDSpawner *s = [[TDSpawner alloc] initWithX:x andY:y andDirection:dir andWAV:75 andMultiplier:1.2 onField:self];
            [spawnerArray addObject:s];
            
            
            [self changeBlockType:SPAWNER:x:y];
            [self changeBlockDirection:dir:x:y];
//            NSLog(@"[%d][%f][%f]",[self blockTypeAtX:x andY:y],x,y);
        }
        self.spawners = spawnerArray;
        
        NSArray *roads = [level objectForKey:@"Road"];
        NSMutableArray *roadArray = [NSMutableArray new];
        for (NSDictionary *road in roads) {
            float x = [[road objectForKey:@"X"] floatValue];
            float y = [[road objectForKey:@"Y"] floatValue];
            BOOL turn = [[road objectForKey:@"Turn"] boolValue];
            int dir = [[road objectForKey:@"Direction"] floatValue];
            int back = [[road objectForKey:@"Backward"] intValue];
            TDRoad *r = [[TDRoad alloc] initWithX:x andY:y andTurn:turn andDirection:dir];
            [roadArray addObject:r];
            self.road = roadArray;
            
            int direction = dir;
            int type = ROAD;
            int backward = TURNUP;
            if(turn) {
                switch(direction) {
                    case 0:
                        type = TURNRIGHT;
                        break;
                        
                    case 1:
                        type = TURNUP;
                        break;
                        
                    case 2:
                        type = TURNLEFT;
                        break;
                        
                    case 3:
                        type = TURNDOWN;
                        break;
                        
                    default:
                        break;
                }
                switch(back) {
                    case 0:
                        backward = TURNRIGHT;
                        break;
                        
                    case 1:
                        backward = TURNUP;
                        break;
                        
                    case 2:
                        backward = TURNLEFT;
                        break;
                        
                    case 3:
                        backward = TURNDOWN;
                        break;
                        
                    default:
                        break;
                }
            }
			TDMap *m = [[self.map objectAtIndex:x]objectAtIndex:y];
			m.type = type;
			m.roadDirectionBackward = backward;
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mobDestroyed:) name:@"MobDestroyedNotification" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(missileDestroyed:) name:@"MissileDestroyedNotification" object:nil];
        }
    }
    return self;
}

- (void)addTower:(NSString *)name atX:(int)x andY:(int)y
{ 
    if([self blockTypeAtX:x andY:y] == EMPTY) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
        NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *towers = [root objectForKey:@"Towers"];
        for (NSDictionary *t in towers) {
            NSString *n = [t objectForKey:@"Name"];
            if ([n isEqualToString:name]) {
                float cost = [[t objectForKey:@"Cost"]floatValue];
                if(cost <= self.money) {
                    [self addMoney:-cost];
                    TDTower *tower = [[TDTower alloc] initWithName:name atX:x andY:y onField:self];
                    if (tower) {
                        [self changeBlockType:TOWER:x:y];
                        [self.towers addObject:tower];
                    }
                }
                break;
            }
        }
    }
}

-(void)spawnMob:(NSString *)name atX:(int)x andY:(int)y {
    //TDMob *m = [TDMob new];
    //add m to self.mobs
}

- (TDBase *)findBaseAtX:(int)x andY:(int)y
{
    for (TDBase *b in self.bases) {
        int baseX = b.x;
        int baseY = b.y;
        if (x>=baseX && x-baseX<2 && y>=baseY && y-baseY<2) {
            return b;
        }
    }
    return nil;
}

- (TDTower *)findTowerAtX:(int)x andY:(int)y
{
	for (TDTower *t in self.towers) {
        if (x == (int)t.x && y == (int)t.y) {
            return t;
        }
	}
	return nil;
}

-(void)addMoney:(float)money
{
    self.money += money;
}

- (int)blockTypeAtX:(int)x andY:(int)y
{
	if (x>=0 && x<self.width && y>=0 && y<self.height) {
        TDMap *m = [[self.map objectAtIndex:x] objectAtIndex:y];
		return m.type;
	}
	else {
		return NONE;
	}

}

-(void)changeBlockType:(int)type:(int)x:(int)y {
    TDMap *m = [[self.map objectAtIndex:x]objectAtIndex:y];
    m.type = type;
}

-(void)changeBlockDirection:(int)dir:(int)x:(int)y {
    TDMap *m = [[self.map objectAtIndex:x]objectAtIndex:y];
    m.type = dir;
}

- (void)dealloc
{
    self.bases = nil;
    self.spawners = nil;
    self.road = nil;
    
    for (NSMutableArray *row in self.map) {
        [row removeAllObjects];
    }
    [self.map removeAllObjects];
    self.map = nil;
    
    [self.mobs removeAllObjects];
    self.mobs = nil;
    
    [self.towers removeAllObjects];
    self.towers = nil;
    
    [self.missiles removeAllObjects];
    self.missiles = nil;
    	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
