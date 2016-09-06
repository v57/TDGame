//
//  TDEffect.m
//  TDGame
//
//  Created by Dmitry Kozlov on 13.11.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDEffect.h"

@implementation TDEffect

-(id)initWithType:(int)type andStrength:(int)strength {
    self.type = type;
    self.strength = strength;
    switch (self.type) {
        case FREEZE:
            self.time = FREEZETIME;
            break;
        case COLD:
            self.time = COLDTIME;
            break;
        case BURN:
            self.time = BURNTIME;
            break;
        case LIQUID:
            self.time = LIQUIDTIME;
            break;
        case STUN:
            self.time = STUNTIME;
            break;
        case VISIBLE:
            self.aura = YES;
            self.time = VISIBLETIME;
            break;
        default:
            break;
    }
    return self;
}

@end
