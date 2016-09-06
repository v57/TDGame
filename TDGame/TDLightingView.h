//
//  TDLightingView.h
//  TDGame
//
//  Created by Dmitry Kozlov on 21.10.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDMob;
@class TDTower;
@class TDFieldView;

@interface TDLightingView : UIView
@property TDTower *tower;
@property TDMob *mob;
@property float blockSize;
@property float tick;

- (id)initWithCell:(float)tick:(TDTower *)tower:(TDMob *)mob onFieldView:(TDFieldView *)fieldView;
@end
