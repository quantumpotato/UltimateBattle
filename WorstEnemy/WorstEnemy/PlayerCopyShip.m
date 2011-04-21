//
//  PlayerCopyShip.m
//  ultimatebattle
//
//  Created by X3N0 on 3/17/11.
//  Copyright 2011 Rage Creations. All rights reserved.
//

#import "PlayerCopyShip.h"


@implementation PlayerCopyShip

-(id)initWithYFacing:(int)facing {
	self = [super initWithYFacing:facing];
	if (self) {
		self.sprite = [CCSprite spriteWithFile:@"Shp2_Bank2_30.png"];
		self.l = CGPointMake(160,230);
	}
	return self;
}


-(void)tick{
	[super tick];
	//Store this current turn

	NSLog(@"player x/y: %f %f",self.sprite.position.x,self.sprite.position.y);
	
    Turn *t = [[Turn alloc] init];
    t.vel = self.turn.vel;
    t.firing = self.turn.firing;
    t.targetLocation = self.turn.targetLocation;
    t.weaponIndex = self.turn.weaponIndex;
	[self.moves addObject:t];
    [t release];
    
	//Clear out the turn's instructions
//	[self.turn becomeEmptyTurn];
}	

@end