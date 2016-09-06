//
//  TDRoad.h
//  TDGame
//
//  Created by Сергей on 23.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDCell.h"

@interface TDRoad : TDCell
@property BOOL turn;
@property float direction;

- (id)initWithX:(float)x andY:(float)y andTurn:(BOOL)turn andDirection:(float)direction;
@end
