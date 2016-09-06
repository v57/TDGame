//
//  TDCell.m
//  TDGame
//
//  Created by Сергей on 23.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDCell.h"

@implementation TDCell

- (id)initWithX:(float)x andY:(float)y
{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
        self.width = self.height = 1.0f;
        self.offsetX = self.offsetY = 0.0f;
    }
    return self;
}

@end
