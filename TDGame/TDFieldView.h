//
//  TDFieldView.h
//  TDGame
//
//  Created by Сергей on 26.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#define GRID_SHOW NO
#define GRID_SIZE 2
#define TITLE_SIZE 15.0f
#define ICON_SIZE 30.0f
#define ICON_INDENT .0f
#define LIMIT_LABEL 300

#ifndef BG_COLOR
#define BG_COLOR [UIColor whiteColor]
#endif

#define GRID_COLOR [UIColor lightGrayColor]

#import <UIKit/UIKit.h>
@class TDField;

@interface TDFieldView : UIView
@property float gridSize;
@property float cellSize;
@property (strong, nonatomic) TDField *field;
@property (strong, nonatomic) NSMutableArray *lightings;
@property (strong, nonatomic) NSMutableArray *labels;

- (id)initWithMainView:(UIView *)mainView andField:(TDField *)field inRect:(CGRect)rect;
-(void)tick:(NSTimeInterval)timeInterval;
-(void)addLabel:(NSString*)text:(float)x:(float)y;
@end
