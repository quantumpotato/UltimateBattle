#import "QPBattlefield.h"

@implementation QPBattlefield
@synthesize currentState = _currentState;
@synthesize titleState = _titleState;
@synthesize drawingState = _drawingState;
@synthesize playerTouch = _playerTouch;
@synthesize lastPlayerTouch = _lastPlayerTouch;
@synthesize touchPlayerOffset = _touchPlayerOffset;
@synthesize pausedState = _pausedState;
@synthesize drawingIteration = _drawingIteration;
@synthesize fightingIteration = _fightingIteration;
@synthesize fightingState =_fightingState;

- (void)setupStates {
    self.currentState = [[[QPBFState alloc] initWithBattlefield:self] autorelease];
    self.titleState = [[[QPBFTitleState alloc] initWithBattlefield:self] autorelease];
    self.drawingState = [[[QPBFDrawingState alloc] initWithBattlefield:self] autorelease];
    self.pausedState = [[[QPBFPausedState alloc] initWithBattlefield:self] autorelease];
    self.fightingState = [[[QPBFFightingState alloc] initWithBattlefield:self] autorelease];
    
    self.currentState = self.titleState;
}

- (id)initWithLayer:(CCLayer *)quantumLayer {
    self = [super initWithLayer:quantumLayer];
    [self setupStates];
    return self;
}

- (void)tick {
    [self.currentState tick];
    self.lastPlayerTouch = self.playerTouch;
    [self.player tick];
}

- (void)addTouch:(CGPoint)l {
    [self.currentState addTouch:l];
}

- (void)endTouch:(CGPoint)l {
    [self.currentState endTouch:l];
}

- (void)moveTouch:(CGPoint)l {
    [self.currentState moveTouch:l];
}

- (void)changeState:(QPBFState *)state {
    self.currentState = state;
}

- (void)changeState:(QPBFState *)state withTouch:(CGPoint)l {
    [self changeState:state];
    [self.currentState addTouch:l];
}

- (float)xDelta:(NSInteger)index {
    return _xDelta[index];
}

- (float)yDelta:(NSInteger)index {
    return _yDelta[index];
}

- (void)addXDelta:(float)delta {
    if (self.drawingIteration < QPBF_MAX_DRAWING_FRAMES) {
        _xDelta[self.drawingIteration] = delta;
    }
}

- (void)addYDelta:(float)delta {
    if (self.drawingIteration < QPBF_MAX_DRAWING_FRAMES) {    
        _yDelta[self.drawingIteration] = delta;
    }
}

- (BOOL)touchingPlayer:(CGPoint)l {
    return GetDistance(l, self.player.l) <= QPBF_PLAYER_TAP_RANGE;
}

- (void)dealloc {
    [_currentState release];
    [_titleState release];
    [_drawingState release];
    [_pausedState release];
    [_fightingState release];
    
    [super dealloc];
}

@end