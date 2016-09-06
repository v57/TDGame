//
//  TDBase.m
//  TDGame
//
//  Created by Сергей on 23.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDBase.h"

@implementation TDBase

- (id)initWithX:(float)x andY:(float)y andHealth:(float)health
{
    self = [super initWithX:x andY:y];
    if (self) {
        self.width = 2.0f;
        self.height = 2.0f;
        self.initialHealth = self.health = health;
        self.partOfHealth = 5;
    }
    return self;
}

- (void)receiveDamage:(float)hit
{
    self.health -= hit;
    //NSLog(@"The base was hit. %.0f health left", self.health);
    int partOfHealth = ceil(self.health/self.initialHealth/0.2f);
    if (partOfHealth < self.partOfHealth) {
        self.partOfHealth = partOfHealth;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BaseLoseHealthNotification" object:self];
    }
    if (self.health <= 0) {
        NSLog(@"GAME OVER, base destroyed!!!");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameOverNotification" object:self];
    }
}

@end
