#import "QPBFTitleState.h"
#import "QPBattlefield.h"

@implementation QPBFTitleState

- (void)activate:(NSDictionary *)options {
    [super activate:options];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TitleLabel" object:@{@"x":[NSNumber numberWithInteger:    [[UIScreen mainScreen] bounds].size.width / 2], @"y" : [NSNumber numberWithInteger:12], @"text" : @"QUANTUM PILOT"}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WeaponLabel" object:[NSNumber numberWithInteger:-1]];
    [self.f resetLineXDirection:1];
    [self resetTimer];
    _showingScore = false;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSocial" object:@""];
}

- (void)addTouch:(CGPoint)l {
    float yLimit = [[UIScreen mainScreen] bounds].size.height;
    yLimit = yLimit * 2/3;
    if ([self.f touchingPlayer:l]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSocial" object:nil];
        [self.f setTouchOffsetFromPilotNear:l];
        [self.f changeState:self.f.drawingState withTouch:l];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TitleLabel" object:@{@"x":[NSNumber numberWithInteger:    [[UIScreen mainScreen] bounds].size.width / 2], @"y" : [NSNumber numberWithInteger:-5000], @"text" : @"QUANTUM PILOT"}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubtitleLabel" object:@{@"x":[NSNumber numberWithInteger:    [[UIScreen mainScreen] bounds].size.width / 2], @"y" : [NSNumber numberWithInteger:-5000], @"text" : @"QUANTUM PILOT"}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScorePulse" object:@"title"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreLabel" object:@"0"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AccuracyPulse" object:@"title"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PathsPulse" object:@"title"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SpeedLabel" object:@""];
        
        [self.f.pilot announceWeapon];
        [self.f resetScoringTotals];
        
        [self.f resetLineXDirection:-1];
    } else if (l.y > yLimit) {
        [self handleTopTap:l.x];
    }
    
    [self.f restGuideMode];
}

- (void)handleTopTap:(float)x {

}

- (void)resetTimer {
    _timer = 80;
}

- (void)pulse {
    _timer --;
    if (_timer <= 0) {
        [self resetTimer];
        _showingScore = !_showingScore;
        if (_showingScore) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowScores" object:@""];
        } else {
            if ([self.f showSocial]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSocial" object:@""];
            }
        }
    }
}

- (bool)showingScore {
    return _showingScore;
}

@end
