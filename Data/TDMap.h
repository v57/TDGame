//
//  TDMap.h
//  TDGame
//
//  Created by Dmitry Kozlov on 13.11.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TDTower;

typedef enum
{
	NONE = 0,
	EMPTY,
	ROAD,
	TURNRIGHT,
	TURNUP,
	TURNLEFT,
	TURNDOWN,
	SPAWNER,
	BASE,
    TOWER
} CELLTYPES;

@interface TDMap : NSObject
@property int type;
@property TDTower *tower;
@property int roadDirection;
@property int roadDirectionBackward;


@end
