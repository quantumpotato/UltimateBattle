//
//  Weapon.m
//  Clone Pilot
//
//  Created by Anthony Broussard on 10/15/11.
//  Copyright 2011 Anthony Broussard. All rights reserved.
//

#import "Weapon.h"
#import "cocos2d.h"

@implementation Weapon
@synthesize speed;

- (id)init {
    self = [super init];
    if (self) {
        self.speed = [[self class] defaultSpeed];
    }
    return self;
}

- (NSArray *)newBullets {
    return [NSArray array];
}

- (NSArray *)newBulletsForLocation:(CGPoint)location direction:(NSInteger)direction {
    return [NSArray array];
}

+ (NSString *)description {
    return NSStringFromClass([self class]);    
}

- (NSString *)description {
    return [[self class] description];
}

+ (float)defaultSpeed {
    return 5.1; //10, //6.8
}

-(id)copyWithZone:(NSZone *)zone {
    id another = [[[self class] alloc] init];
    ((Weapon *)another).speed = self.speed;
    return another;
}

- (void)setDrawColor {
    glColor4f(1, 1, 1, 1.0);
}

@end