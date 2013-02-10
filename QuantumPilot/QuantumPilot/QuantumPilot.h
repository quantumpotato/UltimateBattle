#import "CCNode.h"
#import "cocos2d.h"
#import "QPBulletDelegate.h"
#import "Bullet.h"
#define QPBF_PLAYER_TAP_RANGE 120
#import "Weapon.h"

@protocol QuantumPilotingDelegate;

@class QuantumClone;


@interface QuantumPilot : CCNode {
    CGPoint outerEdges[4];
    CGPoint innerTopEdge;
}

@property (nonatomic) CGPoint l;
@property (nonatomic) CGPoint vel;
@property (nonatomic) CGPoint t;
@property (nonatomic, readonly) float speed;
@property (nonatomic) BOOL firing;

@property (nonatomic) NSInteger fightingIteration;
@property (nonatomic) NSInteger drawingIteration;
@property (nonatomic) NSInteger time;
@property (nonatomic) Weapon *weapon;

@property (nonatomic, retain) QuantumClone *clone;

@property (nonatomic, strong) NSString *bulletName;

@property (nonatomic, assign) id <QPBulletDelegate> bulletDelegate;
@property (nonatomic, assign) id <QuantumPilotingDelegate> pilotDelegate;

@property (strong, nonatomic) Class bulletClass;

- (void)pulse;
- (void)fire;

- (BOOL)isFiring;

- (void)addWaypoint:(CGPoint)l;
- (void)resetIterations;

- (CGPoint)deltasAtIndex:(NSInteger)index;
- (CGPoint)deltaTarget;

- (BOOL)isCollidingWithBullet:(Bullet *)b;
//- (void)hitByBullet:

- (CGPoint *)drawShape;

- (BOOL)touchesPoint:(CGPoint)l;

@end

@protocol QuantumPilotingDelegate <NSObject>

- (void)pilotReachedEndOfFutureWaypoints;

@end
