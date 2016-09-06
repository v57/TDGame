//
//  TDPlayButtonView.h
//  TDGame
//
//  Created by Dmitry Kozlov on 30.11.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDPlayButtonView : UIView
@property BOOL play;
-(id)initWithFrame:(CGRect)frame andPlay:(BOOL)play;
@end
