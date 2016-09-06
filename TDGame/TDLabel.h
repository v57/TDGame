//
//  TDLabel.h
//  TDGame
//
//  Created by Dmitry Kozlov on 04.11.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//
#define PHYSY -400.0f
#define PHYSX .0f

#define MINX -100.0f
#define MAXX 100.0f

#define MINY 100.0f
#define MAXY 300.0f

#define TIMETOREMOVE .4f
#define TIMETOHIDE 0.1f
#define TIMETOSTOP .0f
#define LABELSIZE 12.0f
#import <UIKit/UIKit.h>

@class TDFieldView;
@interface TDLabel : UIView
@property float x;
@property float y;
@property float dx;
@property float dy;
@property float timeToRemove;
@property float blockSize;
@property (strong, nonatomic) TDFieldView *field;
@property (strong, nonatomic) NSString *text;

-(id)initWithx:(float)x andY:(float)y andText:(NSString*)text onFieldView:(TDFieldView *)fieldView;
-(void)tick:(NSTimeInterval)timeInterval;
@end
