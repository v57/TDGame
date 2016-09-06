//
//  TDMobView.h
//  TDGame
//
//  Created by Сергей on 22.09.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDCellView.h"
@class TDMob;

@interface TDMobView : TDCellView
- (id)initWithMob:(TDMob *)mob onFieldView:(TDFieldView *)fieldView;

- (void)rotateMobView;
- (void)rotateDrawContext:(CGContextRef)context inRect:(CGRect)rect;
//- (void)drawBounds;
@end
