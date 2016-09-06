//
//  TDEffect.h
//  TDGame
//
//  Created by Dmitry Kozlov on 13.11.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import <Foundation/Foundation.h>
#define COLDTIME 10.0f
#define FREEZETIME 10.0f
#define BURNTIME 10.0f
#define LIQUIDTIME 10.0f
#define STUNTIME 1.0f
#define VISIBLETIME 3.0f
typedef enum
{
	COLD = 0,
	FREEZE,
	BURN,
    LIQUID,
    STUN,
    VISIBLE
} EFFECTTYPE;

@interface TDEffect : NSObject

@property int type;
@property float time;
@property float strength;
@property BOOL firstTick;
@property BOOL aura;
@property uint index;
-(id)initWithType:(int)type andStrength:(int)strength;
@end
