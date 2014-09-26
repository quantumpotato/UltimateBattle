//
//  TightSpiralLaserCannon.m
//  QuantumPilot
//
//  Created by quantum on 26/09/2014.
//
//

#import "TightSpiralLaserCannon.h"
#import "cocos2d.h"
#import "TightSpiralLaser.h"

@implementation TightSpiralLaserCannon

+ (NSArray *)bulletsForLocation:(CGPoint)location direction:(NSInteger)direction {
    TightSpiralLaser *b1 = [[TightSpiralLaser alloc] initWithLocation:ccp(location.x - 15, location.y) velocity:ccp(-6, [self speed] * direction)];
    TightSpiralLaser *b2 = [[TightSpiralLaser alloc] initWithLocation:ccp(location.x + 15, location.y) velocity:ccp(6, [self speed] * direction)];
    
    return @[b1, b2];
}

+ (void)setDrawColor {
    ccDrawColor4F(.3, .7, .65, 1);
}

@end
