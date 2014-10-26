//
//  QuantumClone.m
//  QuantumPilot
//
//  Created by X3N0 on 10/22/12.
//
//

#import "QuantumClone.h"
#import "SingleLaserCannon.h"
#import "Arsenal.h"
#import "QPBattlefield.h"

@implementation QuantumClone

static int fireSignalValue = 89;

- (id)copyWithZone:(NSZone *)zone {
    QuantumClone *c = [[[QuantumClone alloc] init] autorelease];
    c.weapon = self.weapon;
    for (NSInteger i = 0; i < 4551; i++) {
        [c recordVelocity:pastVelocities[i] firing:pastFireTimings[i] weapon:pastWeapons[i]];
        [c increaseTime];
    }
    [c recordLatestIndex:timeIndex];
    return c;
}

- (void)resetPosition {
//    self.l = CGPointMake(384, 1024-170);
    self.l = CGPointMake(160, 578 * 2/3);
}

- (NSInteger)yDirection {
    return 1;
}

- (BOOL)isFiring {
    return pastFireTimings[timeIndex];
}

- (void)sendBulletsToBattlefield  {
//    Class w = NSClassFromString(self.weapon);
    Class w = [Arsenal weaponIndexedFromArsenal:[self pastWeapon]];
    [self.bulletDelegate cloneBulletsFired:[w bulletsForLocation:outerEdges[0] direction:[self fireDirection]]];

}

- (void)recordVelocity:(CGPoint)vel firing:(BOOL)firing weapon:(CGPoint)wep {
    int t = timeIndex;
    CGPoint p = pastVelocities[t];
    p.x = vel.x;
    p.y = vel.y;
    pastVelocities[t] = p;
    bool fired = firing;
    pastFireTimings[t] = fired;
    
    CGPoint wp = pastWeapons[t];
    wp.x = wep.x;
    wp.y = wep.y;
    pastWeapons[t] = wp;
}

- (void)recordLatestIndex:(NSInteger)index {
    latestIndex = index;
}

- (bool)shouldDraw {
    return self.active;
}

- (void)increaseTime {
    timeIndex++;
}

- (void)changeTime {
    timeIndex+= timeDirection;
}

- (void)moveByVelocity {
    self.vel = pastVelocities[timeIndex];
    if (timeDirection == backwards) {
        self.vel = ccp(-self.vel.x, -self.vel.y);
    }
    [super moveByVelocity];
}

- (void)fireByWeapons {
    if (fireSignal > 0) {
        fireSignal--;
    }
    [self checkForFiringWeapon];
}

- (void)moveThroughTime {
    [self changeTime];
    
    if (timeIndex >= latestIndex) {
        timeIndex = latestIndex;
        timeDirection = backwards;
    } else if (timeIndex < 0) {
        timeIndex = 0;
        timeDirection = forwards;
    }
    
//    int pt = [[[QPBattlefield f] pilot] time];
//    NSLog(@"c time: %d p time: %d", timeIndex, pt);
}

- (void)pulse {
    if (timeDirection != recording) {
        if (self.active) {
            [self moveByVelocity];
            [self fireByWeapons];
            [self moveThroughTime];
        } else {
            [self resetPosition];
        }
    } else {
        [self increaseTime];
    }
    [self defineEdges];
    radius = (float)fireSignal/(float)fireSignalValue * 1.7;
}

- (int)pastWeapon {
    return pastWeapons[timeIndex].x;
}

- (void)setShipDrawColor {
    if (timeDirection == recording) {
        ccDrawColor4F(1, 1, 1, 1.0);
    } else {
        [[Arsenal weaponIndexedFromArsenal:[self pastWeapon]] setDrawColor];
//        [NSClassFromString(self.weapon) setDrawColor];
    }
}

- (void)drawCircle {
    if (fireSignal > 0) {
        ccDrawFilledCircle(self.innerTopEdge, radius, 0, 10, NO);
    }
}

- (void)activate {
    [self resetPosition];
    self.active = true;
    timeIndex = 0;
    timeDirection = forwards;
}

- (void)showFireSignal {
    int index = timeIndex;
    if (timeDirection == forwards) {
        index += fireSignalValue;
        if (index > latestIndex) {
            int diff = latestIndex - index;
            index = latestIndex - diff;
        }
    } else {
        index -= fireSignalValue;
        if (index < 0) {
            int diff = 0 - index;
            index = 0 - diff;
        }
    }
    
    if (pastFireTimings[index] == true) {
        fireSignal = fireSignalValue;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"x: %f y: %f wep: %@ on: %d", self.l.x, self.l.y, self.weapon, self.active];
}

@end
