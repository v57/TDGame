//
//  TDBase.h
//  TDGame
//
//  Created by Сергей on 23.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDCell.h"

@interface TDBase : TDCell
@property float health;
@property float initialHealth;
@property int partOfHealth;

- (id)initWithX:(float)x andY:(float)y andHealth:(float)health;
- (void)receiveDamage:(float)hit;
@end
