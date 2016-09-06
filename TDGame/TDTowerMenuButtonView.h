//
//  TDTowerMenuButtonView.h
//  TDGame
//
//  Created by Дмитрий on 02.12.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDTowerMenuButtonView : UIView
@property int type;
@property float angle;
-(id)initWithFrame:(CGRect)frame andType:(int)type;
@end
