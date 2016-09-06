//
//  TDViewController.m
//  TDGame
//
//  Created by Сергей on 19.08.12.
//  Copyright (c) 2012 SNK. All rights reserved.
//

#import "TDViewController.h"
#import "TDField.h"
#import "TDFieldView.h"
#import "TDTowerView.h"
#import "TDRangeCircleView.h"
#import "TDTowerMenuView.h"
#import "TDBase.h"
#import "TDMap.h"
#import "TDTower.h"
#import "TDMob.h"
#import "TDTowerListView.h"
#import "TDPlayButtonView.h"
#import "TDUpSpeedView.h"
#import "TDDownSpeedView.h"
#import "TDTowerMenuButtonView.h"

@interface TDViewController ()

@end

@implementation TDViewController

- (BOOL)checkDistanceFor:(float)x1 and:(float)y1 with:(float)x2 and:(float)y2 by:(float)dist
{
    float dx = x1 - x2;
    float dy = y1 - y2;
    return (dx*dx + dy*dy < dist*dist);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.mainView];
    self.prevTouchX = point.x;
    self.prevTouchY = point.y;
	if (self.towerMenuView && CGRectContainsPoint(self.towerMenuView.frame, point)) {
        float tx = self.fieldRect.origin.x + self.towerMenuView.frame.origin.x+TOWERMENUSIZE/2;
        float ty = self.fieldRect.origin.y + self.towerMenuView.frame.origin.y+TOWERMENUSIZE/2;
        float dx = point.x - tx;
        float dy = ty - point.y;
        float dist = sqrt(dx*dx + dy*dy);
        float range = TOWERMENUSIZE/2;
        if(dist<=range) {
            float ax = dx/dist;
            float ay = dy/dist;
            float angle = acosf(ax);
            if(ay<0) {angle = -angle;}
            float M_PI_6 = M_PI/6;
            
            if(angle > M_PI_2 || angle < -M_PI+M_PI_6) {
                [self towerButton:1];
            }
            else if(angle > -M_PI_6 && angle < M_PI_2) {
                [self towerButton:2];
            }
            else if(angle > -M_PI+M_PI_6 && angle < -M_PI_6) {
                [self towerButton:3];
            }
            
        }
        else {[self hideTowerMenu];}
        
	}
    else {
        if(self.towerMenuView) {[self hideTowerMenu];}
        if(CGRectContainsPoint(self.towerMenuButtonRect, point)) {
            [self downMenuButton];
        }
        else if(self.menuOpened && CGRectContainsPoint(self.buttonsMenuView.frame, point)) {
            CGPoint p = [touch locationInView:self.buttonsMenuView];
            if(CGRectContainsPoint(self.playStopView.frame, p)) {
                [self playstop];
            }
            else if(CGRectContainsPoint(self.upSpeedView.frame, p)) {
                [self addSpeed];
            }
            else if(CGRectContainsPoint(self.downSpeedView.frame, p)) {
                [self reduceSpeed];
            }
        }
        else if(self.menuOpened && CGRectContainsPoint(self.towerListMenuRect, point)) {
            CGPoint p = [touch locationInView:self.towerListMenuView];
            self.tappedOnMenu = YES;
            for (NSString *n in [self.menuTowerItems allKeys]) {
                TDTowerView *v = [self.menuTowerItems objectForKey:n];
                CGRect rect = v.frame;
                if (CGRectContainsPoint(rect, p)) {
                    UIImage *img = [v imageByRenderingView];
                    self.selectedTowerView = [[UIImageView alloc] initWithImage:img];
                    self.selectedTowerView.frame = CGRectOffset(rect, self.towerListMenuView.frame.origin.x, self.towerListMenuView.frame.origin.y);
                    [self.mainView addSubview:self.selectedTowerView];
                    self.selectedTowerName = n;
                    self.selectedTowerDX = rect.origin.x - p.x;
                    self.selectedTowerDY = rect.origin.y - p.y;
                    self.towerSelected = YES;
                    self.rangeCircle.alpha = 1.0f;
                    
                    float radius = v.radius;
                    
                    float bs = self.fieldView.cellSize + self.fieldView.gridSize;
                    float s = (radius+radius+1)*bs;
                    float s2 = s/2;
                    self.rangeCircle = [[TDRangeCircleView alloc] initWithFrame:CGRectMake(point.x-s2, point.y-s2, s, s)];
                    self.rangeCircle.size = s;
                    [self.mainView addSubview:self.rangeCircle];
                    if(self.menuOpened) {
                        [self hideTowerList];
                    }
                    break;
                }
            }
        }
        else if(CGRectContainsPoint(self.fieldRect, point)) {
            float bs = self.fieldView.cellSize + self.fieldView.gridSize;
            int px = point.x - self.fieldRect.origin.x;
            int py = point.y - self.fieldRect.origin.y;
            int pbx = px/bs;
            int pby = py/bs;
            int bt = [self.field blockTypeAtX:pbx andY:pby];
            
            if(bt == TOWER && !self.towerMenuView) {
                TDTower *t = [self.field findTowerAtX:pbx andY:pby];
                CGRect rect = CGRectMake(pbx*bs+bs/2-TOWERMENUSIZE/2,pby*bs+bs/2-TOWERMENUSIZE/2,TOWERMENUSIZE,TOWERMENUSIZE);
                int first = UPGRADEBUTTON;
                int second = SELLBUTTON;
                int third = TACTICBUTTON;
                if(t.laser) {
                    third = DIRECTIONBUTTON;
                }
                self.towerMenuView = [[TDTowerMenuView alloc]initWithFrame:rect andTower:t andButtons:first:second:third];
                [self.fieldView addSubview:self.towerMenuView];
                self.selectedTower = t;
                [self showTowerInformation];
                if(self.menuOpened) {[self hideTowerList];}
                CGRect frame = self.towerMenuView.frame;
                self.towerMenuView.frame = CGRectMake(CGRectGetMidX(frame), CGRectGetMidY(frame), 0.0f, 0.0f);
                [UIView animateWithDuration:.3f delay:0.0f options:UIViewAnimationOptionTransitionNone
                                 animations:^{
                                     self.towerMenuView.frame = frame;
                                     self.towerMenuView.alpha = .9f;
                                 }
                                 completion:nil];
            }
            
            else {
                for(TDMob*mob in self.field.mobs.allValues) {
                    CGRect r = [mob getCollisionBox];
                    
                    if(CGRectContainsPoint(CGRectMake(r.origin.x*bs+self.fieldRect.origin.x,r.origin.y*bs+self.fieldRect.origin.y,r.size.width*bs,r.size.height*bs), point)) {
                        self.selectedMob = mob;
                        [self showMobInformation];
                        break;
                    }
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if(self.towerSelected) {
        //CGPoint pointf = [touch locationInView:self.fieldView];
        float blockSize = self.fieldView.cellSize + self.fieldView.gridSize;
        //float tx = (int)((pointf.x - self.selectedTowerDX)/blockSize) * blockSize+self.fieldView.frame.origin.x;
        //float ty = (int)((pointf.y - self.selectedTowerDY)/blockSize) * blockSize+self.fieldView.frame.origin.y;
        float dx = self.fieldRect.origin.x;
        float dy = self.fieldRect.origin.y;
        //float tx = point.x + self.selectedTowerDX;
        //float ty = point.y + self.selectedTowerDY;
        int ix = (point.x - dx) / blockSize;
        int iy = (point.y - dy) / blockSize;
        float tx = ix*blockSize+dx;
        float ty = iy*blockSize+dy;
        
        
        self.selectedTowerView.frame = CGRectMake(tx, ty, blockSize, blockSize);
        float s = self.rangeCircle.size;
        float tc = blockSize/2;
        float cc = tc - s/2;
        self.rangeCircle.frame = CGRectMake(tx+cc, ty+cc, s, s);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.mainView];
    
    if (self.towerSelected) {
        float dx = self.fieldRect.origin.x;
        float dy = self.fieldRect.origin.y;
        
        [UIView animateWithDuration:.3f delay:0.0f options:UIViewAnimationOptionTransitionNone
                         animations:^{
							 self.rangeCircle.frame = CGRectMake(CGRectGetMidX(self.rangeCircle.frame), CGRectGetMidY(self.rangeCircle.frame), 0.0f, 0.0f);
                         }
                         completion:^ (BOOL finished){
                             if (finished) {
                                 [self.rangeCircle removeFromSuperview];
                                 self.rangeCircle = nil;
                             }
                         }];

        [self.selectedTowerView removeFromSuperview];
        self.selectedTowerView = nil;
        int fieldHeight = self.fieldView.frame.size.height + self.fieldView.frame.origin.y;
        if(point.y > fieldHeight && point.y < fieldHeight + ICON_SIZE*2) {
            
        }
        else {
            int x = (point.x - dx) / (self.fieldView.cellSize + self.fieldView.gridSize);
            int y = (point.y - dy)/ (self.fieldView.cellSize + self.fieldView.gridSize);
            [self.field addTower:self.selectedTowerName atX:x andY:y];
            if(self.menuOpened) {[self showTowerList];}
            self.selectedTowerName = nil;
        }
    }
    else if(CGRectContainsPoint(self.towerMenuButtonRect, point)) {
        [self upMenuButton];
    }
    self.tappedOnMenu = NO;
    self.towerSelected = NO;
}

- (void)gameOver:(NSNotification *)notification
{
    self.isActive = NO;
}

- (void)updateGamePlay
{
    if(self.play) {
        [self.field updateByTime:self.updateTimer.timeInterval*self.gameSpeed];
        [self.fieldView tick:self.updateTimer.timeInterval];
    }
    if(self.lastMoney != self.field.money) {
        [self updateMoney];
    }
    if(self.lastWave != self.field.waveIndex) {
        self.lastWave = self.field.waveIndex;
        [self updateWave];
    }
    [self updateBase];
    if([[[self.ipadInformationView subviews] objectAtIndex:0] alpha] != 0) {[self updateTowerInformation];}
    if([[[self.ipadInformationView subviews] objectAtIndex:1] alpha] != 0) {[self updateMobInformation];}
    
    if (!self.isActive) {
        [self.updateTimer invalidate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"You lose!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)updateBase {
    
    TDBase *b = [self.field.bases objectAtIndex:0];
    self.baseLabel.text = [NSString stringWithFormat:@"%d", (int)b.health];
}

-(void)updateWave {
    self.waveLabel.text = [NSString stringWithFormat:@"%d", self.field.waveIndex];
}

-(void)updateMoney {
    self.lastMoney = self.field.money;
    self.moneyLabel.text = [NSString stringWithFormat:@"%d", (int)self.lastMoney];
    
    for(int i = 0;i<[self.towerMenuViews count];i++) {
        float cost = [[self.towerMenuCosts objectAtIndex:i]floatValue];
        TDTowerView *v = [self.towerMenuViews objectAtIndex:i];
        if(cost>self.lastMoney && v.foregroundColor != [UIColor redColor]) {
            v.foregroundColor = [UIColor redColor];
            [v setNeedsDisplay];
        }
        else if(cost<=self.lastMoney && v.foregroundColor == [UIColor redColor]) {
            v.foregroundColor = [UIColor blackColor];
            [v setNeedsDisplay];
        }

    }
}

-(void)towerButton:(int)n {
    int type = 0;
    if(n==1) type=self.towerMenuView.first.type;
    else if(n==2) type=self.towerMenuView.second.type;
    else if(n==3) type=self.towerMenuView.third.type;
    if(type==UPGRADEBUTTON) [self upgradeTowerButton];
    else if(type==SELLBUTTON) [self sellTowerButton];
    else if(type==TACTICBUTTON) [self tacticTowerButton];
    else if(type==DIRECTIONBUTTON) [self directionTowerButton];
}
-(void)upgradeTowerButton {
    TDTower *tower = self.towerMenuView.owner;
    int cost = tower.upgradeCost;
    if(self.field.money >= cost) {
        [tower upgrade];
        [self.field addMoney:-cost];
        [self showTowerInformation];
        [self hideTowerMenu];
    }
}
-(void)sellTowerButton {
    [self.field sellTower:self.towerMenuView.owner];
    [self hideTowerMenu];
}
-(void)tacticTowerButton {
    
}
-(void)directionTowerButton {
    float angle = [self.towerMenuView rotateButton:DIRECTIONBUTTON];
    self.towerMenuView.owner.targetDirection = angle*M_PI_2;
    self.towerMenuView.owner.laserDirection = angle;
    [self.towerMenuView.owner updateDirection];
    //NSLog(@"[%.1f][%.1f][%.1f]",angle,self.towerMenuView.owner.laserDirectionX,self.towerMenuView.owner.laserDirectionY);
}

-(void)downMenuButton {
    
}

-(void)upMenuButton {
    if(self.menuOpened) {
        self.menuOpened = NO;
        [self hideTowerList];
    }
    else {
        self.menuOpened = YES;
        [self showTowerList];
    }
}

-(void)showTowerList {
    [UIView animateWithDuration:.25f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{self.towerListMenuView.alpha = 1.0f;self.buttonsMenuView.alpha = 1.0f;}completion: nil];
}

-(void)hideTowerList {
    [UIView animateWithDuration:.25f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{self.towerListMenuView.alpha = .0f;self.buttonsMenuView.alpha = .0f;}completion: nil];
}

-(void)hideTowerMenu {
    [self.towerMenuView removeFromSuperview];
    if(self.menuOpened) {[self showTowerList];}
    self.towerMenuView = nil;
    [self hideTowerInformation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int fh = self.mainView.frame.size.height;
    int fw = self.mainView.frame.size.width;
    int th = 0;
    self.informationMenuRect = CGRectMake(0,th,fw,TITLE_SIZE);
    th+=TITLE_SIZE;
    self.fieldRect = CGRectMake(0,th,fw,fh-th);
    th+=fh-th-ICON_SIZE;
    self.towerListMenuRect = CGRectMake(0,th,fw,ICON_SIZE);
    self.menuOpened = NO;
    
	// Do any additional setup after loading the view, typically from a nib.
    self.towerMenuViews = [NSMutableArray new];
    self.towerMenuCosts = [NSMutableArray new];
    
    self.field = [[TDField alloc] initLevel:2];
    self.fieldView = [[TDFieldView alloc] initWithMainView:self.mainView andField:self.field inRect:self.fieldRect];
	self.fieldRect = self.fieldView.frame;
    self.moneyLabel.text = [NSString stringWithFormat:@"%f", self.field.money];
    self.waveLabel.text = [NSString stringWithFormat:@"%d", self.field.waveIndex];
    TDBase *b = [self.field.bases objectAtIndex:0];
    self.baseLabel.text = [NSString stringWithFormat:@"%d", (int)b.health];
    //NSLog(@"%f,%f,%f,%f",self.towerListMenuRect.origin.x,self.towerListMenuRect.origin.y,self.towerListMenuRect.size.width,self.towerListMenuRect.size.height);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *towers = [root objectForKey:@"Towers"];
    NSMutableDictionary *items = [NSMutableDictionary new];
    int textSize = 10;
    float y = textSize;
    float x = 0;
    int towerListSize = (ICON_SIZE+ICON_INDENT) * [towers count];
    int towerListPosX = (self.view.frame.size.width - towerListSize) / 2;
    self.towerListMenuRect = CGRectMake(towerListPosX,self.fieldView.frame.origin.y + self.fieldView.frame.size.height - ICON_SIZE - textSize,towerListSize,ICON_SIZE+textSize);
    
    self.towerListMenuView = [[UIView alloc]initWithFrame:self.towerListMenuRect];
    self.towerListMenuView.alpha = self.menuOpened;
    self.towerListMenuView.backgroundColor = [UIColor colorWithRed:.9f green:.9f blue:1.0f alpha:.7f];
    CGRect rect = CGRectMake(x, y, ICON_SIZE, ICON_SIZE);
    for (NSDictionary *t in towers) {
        NSString *n = [t objectForKey:@"Name"];
        NSString *vn = [NSString stringWithFormat:@"TD%@View", n];
        TDTowerView *v = [[NSClassFromString(vn) alloc] initWithFrame:rect];
        v.radius = [[t objectForKey:@"Range"] floatValue];
        [self.towerListMenuView addSubview:v];
        UILabel *l = [UILabel new];
        l.text = [NSString stringWithFormat:@"%d",[[t objectForKey:@"Cost"]intValue]];
        l.font = self.moneyLabel.font;
		l.textAlignment = NSTextAlignmentCenter;
        l.frame = CGRectMake(rect.origin.x, rect.origin.y -textSize, rect.size.width, textSize);
        l.backgroundColor = [UIColor clearColor];
        [self.towerListMenuView addSubview:l];
        
        [self.towerMenuViews addObject:v];
        [self.towerMenuCosts addObject:[t objectForKey:@"Cost"]];
        
        [items setObject:v forKey:n];
        rect = CGRectOffset(rect, (ICON_SIZE+ICON_INDENT), 0.0f);
    }
    self.towerMenuButtonRect = CGRectMake(self.fieldView.frame.origin.x,self.towerListMenuRect.origin.y+textSize,ICON_SIZE,ICON_SIZE);
    self.towerListView = [[TDTowerListView alloc]initWithFrame:self.towerMenuButtonRect];
    self.menuTowerItems = items;
    
    int menuButtons = 3;
    self.buttonsMenuView = [[UIView alloc]initWithFrame:CGRectMake(self.fieldView.frame.origin.x,self.fieldView.frame.origin.y + self.fieldView.frame.size.height - (menuButtons+1)*ICON_SIZE,ICON_SIZE,ICON_SIZE*menuButtons)];
    self.buttonsMenuView.backgroundColor = [UIColor colorWithRed:.9f green:.9f blue:1.0f alpha:.7f];
    self.buttonsMenuView.alpha = self.menuOpened;
    
    self.upSpeedView = [[TDUpSpeedView alloc]initWithFrame:CGRectMake(0,(menuButtons-3)*ICON_SIZE,ICON_SIZE,ICON_SIZE)];
    self.playStopView = [[TDPlayButtonView alloc]initWithFrame:CGRectMake(0,(menuButtons-2)*ICON_SIZE,ICON_SIZE,ICON_SIZE) andPlay:!self.play];
    self.downSpeedView = [[TDDownSpeedView alloc]initWithFrame:CGRectMake(0,(menuButtons-1)*ICON_SIZE,ICON_SIZE,ICON_SIZE)];
    [self.buttonsMenuView addSubview:self.upSpeedView];
    [self.buttonsMenuView addSubview:self.playStopView];
    [self.buttonsMenuView addSubview:self.downSpeedView];
    
    [self.mainView addSubview:self.fieldView];
    [self.mainView addSubview:self.buttonsMenuView];
    [self.mainView addSubview:self.towerListView];
    [self.mainView addSubview:self.towerListMenuView];
    
    self.gameSpeed = 1.0f;
    self.play = YES;
    [self correctSpeedLabel];
    
    self.isActive = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOver:) name:@"GameOverNotification" object:nil];
    [self createIpadInformation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.field = nil;
    
    [self.fieldView removeFromSuperview];
    self.fieldView = nil;
    
    self.menuTowerItems = nil;
    
    [self.selectedTowerView removeFromSuperview];
    self.selectedTowerView = nil;
    
    self.selectedTowerName = nil;
    
	[self.towerMenuView removeFromSuperview];
	self.towerMenuView = nil;
    
    for (TDTowerMenuView *v in self.towerMenuViews) {
        [v removeFromSuperview];
    }
    [self.towerMenuViews removeAllObjects];
    self.towerMenuViews = nil;
    
    [self.towerMenuCosts removeAllObjects];
    self.towerMenuCosts = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playstop
{
    if(self.play) {
        [self stopGame];
    }
    else {
        [self resumeGame];
    }
}

- (void)stopGame
{
    if(self.play) {
        self.play = NO;
        self.playStopView.play = NO;
        [self.playStopView setNeedsDisplay];
        [self correctSpeedLabel];
    }
}

- (void)resumeGame
{
    if(!self.play) {
        self.play = YES;
        self.playStopView.play = YES;
        [self.playStopView setNeedsDisplay];
        [self correctSpeedLabel];
    }
}

- (void)correctSpeedLabel
{
    if(!self.play || self.gameSpeed == 0) {
        self.speedLabel.text = [NSString stringWithFormat:@"||"];
    }
    else {
        self.speedLabel.text = [NSString stringWithFormat:@"%.1f",self.gameSpeed];
    }
}

- (void)stepSpeed {
    float prevSpeed = self.gameSpeed;
    self.gameSpeed += .5f;
    if(self.gameSpeed >= 10) {
        self.gameSpeed = 0;
    }
    if(self.gameSpeed <=0) {
        self.gameSpeed = 0;
        [self stopGame];
    }
    else if(prevSpeed == 0) {
        [self resumeGame];
    }
    [self correctSpeedLabel];
}
-(void)addSpeed {
    self.gameSpeed += 0.5f;
    if(self.gameSpeed >= 10) {
        self.gameSpeed = 9.5f;
    }
    if(!self.play) {[self resumeGame];}
    [self correctSpeedLabel];
}
-(void)reduceSpeed {
    self.gameSpeed -= 0.5f;
    if(self.gameSpeed <=0) {
        self.gameSpeed = 0;
        [self stopGame];
    }
    [self correctSpeedLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:TICK_INTERVAL target:self selector:@selector(updateGamePlay) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.updateTimer = nil;
}

-(void)createIpadInformation {
    self.ipadInformationView = [[UIView alloc]initWithFrame:CGRectMake(0,self.mainView.frame.size.height,768,1024 - self.mainView.frame.size.height)];
    [self.view addSubview:self.ipadInformationView];
    UIFont *f = self.baseLabel.font;
    [f fontWithSize:20];

    /*tower labels*/ int towerLabels = 5;
    
    UIView *towerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, towerLabels*20+10 , 200)];
    towerView.alpha = .0f;
    [self.ipadInformationView addSubview:towerView];
    for(int i=0;i<towerLabels;i++) {
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(10,20*i+10,200,20)];
        l.font = f;
        l.backgroundColor = [UIColor clearColor];
        [towerView addSubview:l];
    }
    /*tower labels*/ int mobLabels = 7;
    
    UIView *mobView = [[UIView alloc]initWithFrame:CGRectMake(200, 0, mobLabels*20+10 , 200)];
    mobView.alpha = .0f;
    [self.ipadInformationView addSubview:mobView];
    for(int i=0;i<mobLabels;i++) {
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(10,20*i+10,200,20)];
        l.font = f;
        l.backgroundColor = [UIColor clearColor];
        [mobView addSubview:l];
    }
    
}

-(void)showTowerInformation {
    UIView *towerView = [[self.ipadInformationView subviews] objectAtIndex:0];
    [UIView animateWithDuration:.3f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{towerView.alpha = 1.0f;}completion: nil];
}

-(void)hideTowerInformation {
    UIView *towerView = [[self.ipadInformationView subviews] objectAtIndex:0];
    [UIView animateWithDuration:.3f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{towerView.alpha = .0f;}completion: nil];
}

-(void)updateTowerInformation {
    TDTower *t = self.towerMenuView.owner;
    
    NSArray *a = [[NSArray alloc]initWithObjects:
                  [NSString stringWithFormat:@"Name: %@",t.name],
                  [NSString stringWithFormat:@"Level: %d",t.level],
                  [NSString stringWithFormat:@"Damage: %.1f",t.damage],
                  [NSString stringWithFormat:@"Rate per minute: %.1f",t.attackSpeed],
                  [NSString stringWithFormat:@"Upgrade cost: %.1f",t.upgradeCost],
                  nil];
    UIView *towerView = [[self.ipadInformationView subviews] objectAtIndex:0];
    for(int i=0;i<[[towerView subviews]count];i++) {
        UILabel *l = [[towerView subviews]objectAtIndex:i];
        l.text = [a objectAtIndex:i];
    }
}

-(void)showMobInformation {
    UIView *mobView = [[self.ipadInformationView subviews] objectAtIndex:1];
    [UIView animateWithDuration:.3f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{mobView.alpha = 1.0f;}completion: nil];
}

-(void)hideMobInformation {
    UIView *mobView = [[self.ipadInformationView subviews] objectAtIndex:1];
    [UIView animateWithDuration:.3f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{mobView.alpha = .0f;}completion: nil];
}

-(void)updateMobInformation {
    if(self.selectedMob.hp <= 0) {
        [self hideMobInformation];
        return;
    }
    TDMob *m = self.selectedMob;
    
    NSArray *a = [[NSArray alloc]initWithObjects:
                  [NSString stringWithFormat:@"Name: %@",m.name],
                  [NSString stringWithFormat:@"HP: %.1f",m.hp],
                  [NSString stringWithFormat:@"Armor: %.1f",m.armor],
                  [NSString stringWithFormat:@"Position: %.1f , %.1f",m.x,m.y],
                  [NSString stringWithFormat:@"Direction: %.1f",m.direction],
                  [NSString stringWithFormat:@"Speed: %.1f",m.speed],
                  [NSString stringWithFormat:@"Effects: %d",[m.effects count]],
                  nil];
    UIView *mobView = [[self.ipadInformationView subviews] objectAtIndex:1];
    for(int i=0;i<[[mobView subviews]count];i++) {
        UILabel *l = [[mobView subviews]objectAtIndex:i];
        l.text = [a objectAtIndex:i];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end



