#import "QuantumPilot.h"
#import "VRGeometry.h"
#import "QuantumClone.h"
#import "QPBattlefield.h"
#import "SingleLaserCannon.h"

@interface QuantumPilot() {
    CGPoint future[4001];
}

@end

@implementation QuantumPilot
static float shipTopHeight = 50;
static float shipSideWidth = 15;
static float shipBottomHeight = 10;
static float innerTopHeight = 10;
static float innerCircleRadius = 4.5;

- (NSInteger)yDirection {
    return -1;
}

- (void)resetPosition {
    self.l = CGPointMake(384, 170);
}

- (id)init {
    self = [super init];
    if (self) {
        _speed = 4; //6.3
        [self engage];
    }
    return self;
}

- (void)engage {
    [self resetIterations];
    self.weapon = [[SingleLaserCannon alloc] init];
    self.active = YES;
    [self resetPosition];
}

- (void)drawShip {
    outerEdges[0] = ccp(self.l.x, self.l.y - shipTopHeight * [self yDirection]);
    outerEdges[1] = ccp(self.l.x - shipSideWidth, self.l.y);
    outerEdges[2] = ccp(self.l.x, self.l.y + shipBottomHeight * [self yDirection]);
    outerEdges[3] = ccp(self.l.x + shipSideWidth, self.l.y);
    self.innerTopEdge = ccp(self.l.x, self.l.y - innerTopHeight * [self yDirection]);
    
    ccDrawPoly(outerEdges, 4, YES);
}

- (void)drawCircle {
    ccDrawFilledCircle(self.innerTopEdge, innerCircleRadius * [QPBattlefield pulseRotation], 0, 100, NO);
    ccDrawColor4F(1, 1, 1, 1.0);
}

- (void)draw {
    if (self.active) {
        [self drawShip];
        [self drawCircle];
        CGPoint drawingDeltas[4001];
        NSInteger index = 0;
        for (int i = self.fightingIteration; i < self.drawingIteration; i++) {
            drawingDeltas[index] = future[i];
            index++;
        }
        NSInteger drawFrameTotal = self.drawingIteration - self.fightingIteration;
        if (drawFrameTotal < 0) {
            drawFrameTotal = 0;
        }
        ccDrawPoly(drawingDeltas, drawFrameTotal, NO);
    }
}

- (BOOL)isFiring {
    return self.firing;
}

- (NSInteger)fireDirection {
    return -[self yDirection];
}

- (void)sendBulletsToBattlefield {
    [self.bulletDelegate bulletsFired:[self.weapon bulletsForLocation:outerEdges[0] direction:[self fireDirection]]];
}

- (void)checkForFiringWeapon {
    if ([self isFiring]) {
        [self sendBulletsToBattlefield];
    }
}

- (CGPoint)currentWaypoint {
    return future[self.fightingIteration];
}

- (void)calculateTarget {
    self.t = [self currentWaypoint];
}

- (void)calculateVelocityForTarget {
    float distanceToTarget = GetDistance(self.l, self.t);
    if (distanceToTarget >= self.speed) {
        self.vel = GetAngle(self.l, self.t);
        self.vel = MultipliedPoint(self.vel, self.speed);
    } else {
        if (distanceToTarget > 0) {
            self.vel = GetAngle(self.l, self.t);
            self.vel = MultipliedPoint(self.vel, distanceToTarget);
        } else {
            self.vel = CGPointZero;
        }
    }
}

- (void)moveByVelocity {
    self.l = CombinedPoint(self.l, self.vel);
}

- (BOOL)reachedTarget {
    return GetDistance(self.l, [self currentWaypoint]) == 0;
}

- (void)evaluateReachingTarget {
    if ([self reachedTarget]) {
        self.fightingIteration++;
        if (self.fightingIteration == self.drawingIteration) {
            [self.pilotDelegate pilotReachedEndOfFutureWaypoints];
            [self resetIterations];            
        }
    }
}

- (void)setDrawingScaleByBattlefieldRhythm {
    //
}

- (void)copyDeltas {
    [self.clone recordVelocity:ccp(self.vel.x, -self.vel.y) firing:self.firing];
}

- (void)resetFiring {
    self.firing = NO;
}

- (void)pulse {
    [self checkForFiringWeapon];
    [self calculateTarget];
    [self calculateVelocityForTarget];
    [self moveByVelocity];
    [self evaluateReachingTarget];
    [self setDrawingScaleByBattlefieldRhythm];
    
    [self copyDeltas];
    [self resetFiring];
    
    self.time++;
}

- (void)stationaryFire {
    future[self.drawingIteration] = self.l;
    [self fire];
}

- (void)addWaypoint:(CGPoint)l {
    future[self.drawingIteration] = l;
}

- (CGPoint)deltasAtIndex:(NSInteger)index {
    return future[index];
}

- (CGPoint)deltaTarget {
    return future[self.fightingIteration];
}

- (CGPoint *)drawShape {
    return outerEdges;
}

- (BOOL)isCollidingWithBullet:(Bullet *)b {
    return shapeOfSizeContainsPoint([self drawShape], 4, b.l);
}

- (void)registerHit {
    self.active = NO;
}

- (void)processBullet:(Bullet *)b {
    if ([self isCollidingWithBullet:b]) {
        b.l = ccp(5000,5000);
        [self registerHit];
    }
}

- (BOOL)touchesPoint:(CGPoint)l {
    return GetDistance(self.l, l) <= QPBF_PLAYER_TAP_RANGE;
}

- (void)resetIterations {
    self.drawingIteration = 0;
    self.fightingIteration = 0;
}

- (void)fire {
    self.firing = YES;
}

- (void)createClone {
    self.clone = [[QuantumClone alloc] init];
    self.clone.active = YES;
    self.clone.weapon = [[[self.weapon class] alloc] init];
}

@end


