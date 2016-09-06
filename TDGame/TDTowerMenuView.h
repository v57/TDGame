//
//  TDTowerMenuView.h
//  TDGame
//
//  Created by Dmitry Kozlov on 03.11.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//
#import <UIKit/UIKit.h>
@class TDTower;
@class TDTowerMenuButtonView;

typedef enum
{
	UPGRADEBUTTON = 1,
	SELLBUTTON,
	TACTICBUTTON,
    DIRECTIONBUTTON
} TOWERMENUBUTTON;

@interface TDTowerMenuView : UIView
@property (strong, nonatomic) TDTower *owner;
@property (strong, nonatomic) TDTowerMenuButtonView *first;
@property (strong, nonatomic) TDTowerMenuButtonView *second;
@property (strong, nonatomic) TDTowerMenuButtonView *third;
@property float buttonSize;


- (id)initWithFrame:(CGRect)frame andTower:(TDTower*)tower andButtons:(TOWERMENUBUTTON)first:(TOWERMENUBUTTON)second:(TOWERMENUBUTTON)third;
-(float)rotateButton:(int)n;
@end
