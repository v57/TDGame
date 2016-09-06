//
//  TDRoad.m
//  TDGame
//
//  Created by Сергей on 23.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDRoad.h"

@implementation TDRoad

- (id)initWithX:(float)x andY:(float)y andTurn:(BOOL)turn andDirection:(float)direction
{
    self = [super initWithX:x andY:y];
    if (self) {
        self.turn = turn;
        self.direction = direction;
    }
    return self;
}

@end
