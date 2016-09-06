//
//  TDViewController.h
//  TDGame
//
//  Created by Сергей on 19.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#define TICK_INTERVAL 0.025f
#define TOWERMENUSIZE 150.0f

#import <UIKit/UIKit.h>
@class TDField;
@class TDFieldView;
@class TDRangeCircleView;
@class TDTowerMenuView;
@class TDTowerListView;
@class TDTower;
@class TDMob;
@class TDPlayButtonView;
@class TDUpSpeedView;
@class TDDownSpeedView;

@interface TDViewController : UIViewController
@property (retain) NSTimer *updateTimer;
@property int prevTouchX;
@property int prevTouchY;
@property float lastMoney;
@property float lastWave;
@property float lastBase;

//Views
@property (strong, nonatomic) UIImageView *selectedTowerView;
@property (strong, nonatomic) TDTowerListView* towerListView;
@property (strong, nonatomic) UIView* towerListMenuView;
@property (strong, nonatomic) TDField *field;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) TDFieldView *fieldView;
@property (strong, nonatomic) TDTowerMenuView *towerMenuView;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *waveLabel;
@property (strong, nonatomic) IBOutlet UILabel *baseLabel;
@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) TDRangeCircleView *rangeCircle;
@property (strong, nonatomic) UIView* menuView;

@property (strong, nonatomic) UIView* buttonsMenuView;
@property (strong, nonatomic) TDPlayButtonView* playStopView;
@property (strong, nonatomic) TDUpSpeedView* upSpeedView;
@property (strong, nonatomic) TDDownSpeedView* downSpeedView;

//Rects
@property CGRect towerMenuButtonRect;
@property CGRect towerListMenuRect;
@property CGRect informationMenuRect;
@property CGRect fieldRect;

//BOOLs
@property BOOL play;
@property BOOL isActive;
@property BOOL menuOpened;
@property BOOL tappedOnMenu;
@property BOOL towerSelected;
@property BOOL upgradeButtonSelected;
@property BOOL sellButtonSelected;
@property BOOL tacticButtonSelected;


@property (strong, nonatomic) NSMutableArray *towerMenuViews;
@property (strong, nonatomic) NSMutableArray *towerMenuCosts;

@property float gameSpeed;


@property (strong, nonatomic) NSDictionary *menuTowerItems;
@property float selectedTowerDX;
@property float selectedTowerDY;
@property (strong, nonatomic) NSString *selectedTowerName;
@property (strong, nonatomic) TDTower *selectedTower;
@property int prevPosX;
@property int prevPosY;


@property TDMob *selectedMob;
@property UIView *ipadInformationView;



- (void)stopGame;
- (void)resumeGame;

@end
