//
//  TDCellView.h
//  TDGame
//
//  Created by Сергей on 28.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDCell;
@class TDFieldView;

@interface TDCellView : UIView
@property (strong, nonatomic) TDCell *cell;
@property (strong, nonatomic) UIColor *foregroundColor;
@property float blockSize;

- (id)initWithCell:(TDCell *)cell onFieldView:(TDFieldView *)fieldView;
- (void)placeCell;
- (UIImage *)imageByRenderingView;
@end
