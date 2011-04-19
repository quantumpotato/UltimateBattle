//
//  WorstEnemyBattlefield.h
//  WorstEnemy
//
//  Created by X3N0 on 4/18/11.
//  Copyright 2011 Pursuit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCLayer.h"
#import "PlayerCopyShip.h"

@interface WorstEnemyBattlefield : NSObject {
	int level;
	int currentKills;
	NSTimer *timer;
	CGPoint gestureStartPoint, currentPosition;
}

@property(nonatomic, retain) NSMutableArray *copies;
@property(nonatomic, retain) UltimateShip *player;
@property(nonatomic , retain) NSMutableArray *bullets;
@property(nonatomic, retain) CCLayer *layer;

-(void)startGame;
-(void)nextLevel;

-(UltimateWeapon *)newWeaponForLevel:(int)aLevel;
-(id)initWithLayer:(CCLayer *)aLayer;

@end