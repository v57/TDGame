//
//  TDCell.h
//  TDGame
//
//  Created by Сергей on 23.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDCell : NSObject
@property float x;
@property float y;
@property float width;
@property float height;
@property float offsetX;
@property float offsetY;

- (id)initWithX:(float)x andY:(float)y;
@end
