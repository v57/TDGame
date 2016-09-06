//
//  TDFieldView.m
//  TDGame
//
//  Created by Сергей on 26.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDFieldView.h"

#import "TDField.h"
#import "TDRoad.h"
#import "TDSpawner.h"
#import "TDBase.h"
#import "TDRoadView.h"
#import "TDSpawnerView.h"
#import "TDBaseView.h"
#import "TDMob.h"
#import "TDMobView.h"

#import "TDTower.h"
#import "TDTowerView.h"

#import "TDLightingView.h"
#import "TDLabel.h"
#import "TDMap.h"

#import "TDTowerListView.h"

@implementation TDFieldView

- (id)initWithMainView:(UIView *)mainView andField:(TDField *)field inRect:(CGRect)rect
{
    self.field = field;
    self.gridSize = (GRID_SHOW) ? GRID_SIZE : 0.0f;
    
    self.lightings = [NSMutableArray new];
    self.labels = [NSMutableArray new];
    
    float x = rect.origin.x;
    float y = rect.origin.y;
    float width = rect.size.width;
    float height = rect.size.height;
    
    int fieldWidth = field.width;
    int fieldHeight = field.height;
    int cellWidth = (width - (fieldWidth-1)*self.gridSize) / fieldWidth;
    int cellHeight = (height - (fieldHeight-1)*self.gridSize) / fieldHeight;
    self.cellSize = MIN(cellWidth, cellHeight);
    
    float newWidth = (self.cellSize+self.gridSize) * fieldWidth - self.gridSize;
    height = (self.cellSize+self.gridSize) * fieldHeight - self.gridSize;
    x += (width - newWidth) / 2;
    self = [self initWithFrame:CGRectMake(x, y, newWidth, height)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMob:) name:@"NewMobNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newTower:) name:@"NewTowerNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLighting:) name:@"LightingNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hitMob:) name:@"MobHittedNotification" object:nil];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = BG_COLOR;
        
        for(TDSpawner *s in self.field.spawners) {
            TDSpawnerView *sv = [[TDSpawnerView alloc] initWithCell:s onFieldView:self];
            [self addSubview:sv];
        }
        
        for(TDBase *b in self.field.bases) {
            TDBaseView *bv = [[TDBaseView alloc] initWithCell:b onFieldView:self];
            [self addSubview:bv];
        }
    }
    return self;
}

-(void)addLabel:(NSString*)text:(float)x:(float)y
{
    if([self.labels count] <= LIMIT_LABEL) {
        TDLabel *v = [[TDLabel alloc]initWithx:x andY:y andText:text onFieldView:self];
        [self addSubview:v];
        [self.labels addObject:v];
    }
}

-(void)removeLabel:(uint)i
{
    [[self.labels objectAtIndex:i]removeFromSuperview];
    [self.labels removeObjectAtIndex:i];
}

-(void)removeLabelObject:(TDLabel*)v
{
    [v removeFromSuperview];
    [self.labels removeObject:v];
}

-(void)labelTick:(NSTimeInterval)timeInterval
{
    int c = [self.labels count];
    if(c) {
        int a = 0;
        NSMutableArray *ma;
        for(TDLabel *v in self.labels) {
            v.timeToRemove-=timeInterval;
            [v tick:timeInterval];
            if(v.timeToRemove<=0) {
                if(a==0) {
                    ma = [NSMutableArray new]; 
                }
                a ++;
                [ma addObject:v];
            }

        }
        
        if(a) {
            for(TDLabel* n in ma) {
                
                [self removeLabelObject:n];
            }
        }

    }
}

- (void)addLighting:(NSNotification *)notification
{
    TDTower *t = [notification object];
    TDLightingView *v = [[TDLightingView alloc]initWithCell:0.5f:t :t.target onFieldView:self];
    [self addSubview:v];
    [self.lightings addObject:v];
}

-(void)removeLighting:(uint)i
{
    [[self.lightings objectAtIndex:i] removeFromSuperview];
    [self.lightings removeObjectAtIndex:i];
}

-(void)lightingTick:(NSTimeInterval)timeInterval
{
    if([self.lightings count]) {
        for(TDLightingView *l in self.lightings) {
            [l setNeedsDisplay];
            l.tick -= timeInterval;
            uint i = [self.lightings indexOfObject:l];
            if(l.tick <= 0) {
                [self removeLighting:i];
            }
        }
    }
}


- (void)newMob:(NSNotification *)notification
{
    TDMob *m = [notification object];
    NSString *viewName = [NSString stringWithFormat:@"TD%@View", m.name];
    if (viewName) {
        TDMobView *v = [[NSClassFromString(viewName) alloc] initWithMob:m onFieldView:self];
        [self addSubview:v];
    } else {
        NSLog(@"ERROR: Mob with name \"%@\" does not exist !!!", m.name);
    }
}

- (void)newTower:(NSNotification *)notification
{
    TDTower *tower = [notification object];
    NSString *viewName = [NSString stringWithFormat:@"TD%@View", tower.name];
    TDTowerView *v = [[NSClassFromString(viewName) alloc] initWithTower:tower onFieldView:self];
    [self addSubview:v];
}

- (void)hitMob:(NSNotification *)notification
{
    TDMob *mob = [notification object];
    if(mob.accuredHP >=1) {
        
        [self addLabel:[NSString stringWithFormat:@"%d",(int)mob.accuredHP] :mob.x :mob.y];
    }
}

-(void)tick:(NSTimeInterval)timeInterval
{
    [self lightingTick:timeInterval];
    [self labelTick:timeInterval];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    float blockSize = self.cellSize + self.gridSize;
	if (GRID_SHOW) {
		CGContextSetLineWidth(context, self.gridSize);
		CGContextSetStrokeColorWithColor(context, GRID_COLOR.CGColor);
		for (int x=1; x<self.field.width; x++) {
			float xPos = x*blockSize - self.gridSize/2;
			CGContextMoveToPoint(context, xPos, 0);
			CGContextAddLineToPoint(context, xPos, self.frame.size.height);
		}
		for (int y=1; y<self.field.height; y++) {
			float yPos = y*blockSize - self.gridSize/2;
			CGContextMoveToPoint(context, 0, yPos);
			CGContextAddLineToPoint(context, self.frame.size.width, yPos);
		}
		CGContextStrokePath(context);
	}
    CGContextSetRGBStrokeColor(context, .0f, .0f, .0f, 1.0f);
    for(TDRoad *r in self.field.road) {
        int mUp = [self.field blockTypeAtX:r.x andY:r.y-1];
        int mDown = [self.field blockTypeAtX:r.x andY:r.y+1];
        int mLeft = [self.field blockTypeAtX:r.x-1 andY:r.y];
        int mRight = [self.field blockTypeAtX:r.x+1 andY:r.y];
        if([self checkRoad:mUp]) {
			float x = r.x*blockSize - self.gridSize/2;
			float y = r.y*blockSize - self.gridSize/2;
			CGContextMoveToPoint(context, x, y);
			CGContextAddLineToPoint(context, x+blockSize, y);
        }
        if([self checkRoad:mDown]) {
			float x = r.x*blockSize - self.gridSize/2;
			float y = r.y*blockSize - self.gridSize/2;
			CGContextMoveToPoint(context, x, y+blockSize);
			CGContextAddLineToPoint(context, x+blockSize, y+blockSize);
        }
        if([self checkRoad:mLeft]) {
			float x = r.x*blockSize - self.gridSize/2;
			float y = r.y*blockSize - self.gridSize/2;
			CGContextMoveToPoint(context, x, y);
			CGContextAddLineToPoint(context, x, y+blockSize);
        }
        if([self checkRoad:mRight]) {
			float x = r.x*blockSize - self.gridSize/2;
			float y = r.y*blockSize - self.gridSize/2;
			CGContextMoveToPoint(context, x+blockSize, y);
			CGContextAddLineToPoint(context, x+blockSize, y+blockSize);
        }
    }
    CGContextStrokePath(context);
     
    
}

-(BOOL)checkRoad:(int)m {
    if(m != ROAD && m!=TURNUP && m!=TURNDOWN && m!=TURNLEFT && m!=TURNRIGHT && m!=SPAWNER && m!=BASE) {
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    self.field = nil;
    for (TDLightingView *lv in self.lightings) {
        [lv removeFromSuperview];
    }
    [self.lightings removeAllObjects];
    self.lightings = nil;
    for (TDLabel *l in self.labels) {
        [l removeFromSuperview];
    }
    [self.labels removeAllObjects];
    self.lightings = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
