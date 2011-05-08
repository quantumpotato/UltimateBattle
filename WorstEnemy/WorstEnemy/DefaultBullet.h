//
//  Bullet.h
//  ultimatebattle
//
//  Created by X3N0 on 3/11/11.
//  Copyright 2011 Rage Creations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

#import "UltimateBullet.h"

@interface DefaultBullet : GameObject {
	
	int moveTimer;
	int photoRef;
	float ticker;
}


+(NSArray *)newBulletsWithYFacing:(int)facing from:(CGPoint)from;

@property(nonatomic, retain) UltimateBullet *ub;

-(id)initWithYFacing:(int)facing from:(CGPoint)from;
-(void)setup;

@end
