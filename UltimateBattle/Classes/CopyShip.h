//
//  CopyShip.h
//  ultimatebattle
//
//  Created by X3N0 on 3/17/11.
//  Copyright 2011 Rage Creations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ship.h"

@interface CopyShip : Ship {
	int currentTurnIndex;
}

-(id)initWithShip:(Ship *)ship;

-(void)resetState;

@end