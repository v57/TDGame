//
//  TDCellView.m
//  TDGame
//
//  Created by Сергей on 28.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDCellView.h"
#import "TDCell.h"
#import "TDField.h"
#import "TDFieldView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TDCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.foregroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)placeCell
{
    float x = (self.cell.x + self.cell.offsetX) * self.blockSize;
    float y = (self.cell.y + self.cell.offsetY) * self.blockSize;
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}

- (id)initWithCell:(TDCell *)cell onFieldView:(TDFieldView *)fieldView
{
    self.cell = cell;
    float blockSize = self.blockSize = fieldView.cellSize + fieldView.gridSize;
    float x = (cell.x + cell.offsetX) * blockSize;
    float y = (cell.y + cell.offsetY) * blockSize;
    float width = cell.width * blockSize - fieldView.gridSize;
    float height = cell.height * blockSize - fieldView.gridSize;
    self = [self initWithFrame:CGRectMake(x, y, width, height)];
    return self;
}

- (void)dealloc
{
    self.foregroundColor = nil;
    self.cell = nil;
}

- (UIImage *)imageByRenderingView
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
