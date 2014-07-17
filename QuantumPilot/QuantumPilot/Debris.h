//
//  Debris.h
//  QuantumPilot
//
//  Created by quantum on 15/07/2014.
//
//

#import "cocos2d.h"

@interface Debris : CCNode {
    CGPoint _points[10];
    float _speed;
}

@property (nonatomic) CGPoint l;

- (id)initWithL:(CGPoint)l;

- (void)pulse;

@end