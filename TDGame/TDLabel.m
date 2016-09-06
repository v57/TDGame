//
//  TDLabel.m
//  TDGame
//
//  Created by Dmitry Kozlov on 04.11.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//


#import "TDLabel.h"
#import "TDFieldView.h"

@implementation TDLabel

-(id)initWithx:(float)x andY:(float)y andText:(NSString*)text onFieldView:(TDFieldView *)fieldView {
    self = [self initWithFrame:CGRectMake(x,y,LABELSIZE*text.length+200,LABELSIZE)];
    self.field = fieldView;
    self.blockSize = fieldView.gridSize+fieldView.cellSize;
    self.x = x*self.blockSize;
    self.y = y*self.blockSize;
    self.text = text;
    self.timeToRemove = TIMETOREMOVE;
    float rx = arc4random() % (int)(MAXX-MINX);
    float ry = arc4random() % (int)(MAXY-MINY);
    self.dx = rx+MINX;
    self.dy = ry+MINY;
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)tick:(NSTimeInterval)timeInterval
{
    if(self.timeToRemove <= TIMETOHIDE) {
        self.alpha -= 1/TIMETOHIDE * timeInterval;
    }
    if(self.timeToRemove > TIMETOSTOP) {
        self.x += self.dx*timeInterval;
        self.y -= self.dy*timeInterval;
            self.dx += PHYSX*timeInterval;
        self.dy += PHYSY*timeInterval;
        
        CGRect rect;
        rect.origin.x = self.x;
        rect.origin.y = self.y;
        rect.size = self.frame.size;
        self.frame = rect;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect viewBounds = self.bounds;
    CGContextTranslateCTM(context, 0, viewBounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextSetRGBFillColor(context, .0f, .0f, .0f, 1.0f);
    CGContextSetLineWidth(context, 2.0);
    CGContextSelectFont(context, "Helvetica", LABELSIZE, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(context, 1.7);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    CGContextShowTextAtPoint(context, .0f, .0f, [self.text UTF8String], self.text.length);
}

- (void)dealloc
{
    self.field = nil;
    self.text = nil;
}

-(float)mod:(float)a{if(a>=0){return a;}else{return -a;}}

@end



















