//
//  ultimatebattleViewController.h
//  ultimatebattle
//
//  Created by X3N0 on 3/11/11.
//  Copyright 2011 Rage Creations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UltimateShip.h"

@interface ultimatebattleViewController : UIViewController {
	int level;
	int currentKills;
	NSTimer *timer;
	CGPoint gestureStartPoint, currentPosition;
}

@property(nonatomic, retain) NSMutableArray *copies;
@property(nonatomic, retain) UltimateShip *player;
@property(nonatomic , retain) NSMutableArray *bullets;

-(void)startGame;
-(void)nextLevel;

-(UltimateWeapon *)newWeaponForLevel:(int)aLevel;

@end