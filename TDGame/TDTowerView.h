//
//  TDTowerView.h
//  TDGame
//
//  Created by Сергей on 22.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDCellView.h"
@class TDTower;

@interface TDTowerView : TDCellView
@property float radius;

- (id)initWithTower:(TDTower *)tower onFieldView:(TDFieldView *)fieldView;
- (void)drawBounds:(CGRect)rect;
- (void)rotateTower:(CGRect)rect;
@end
