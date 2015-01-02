#import "QPBattlefield.h"
#import "Bullet.h"
#import "QuantumClone.h"
#import "Debris.h"
#import "WideTriLaserCannon.h"
#import "WideSpiralLaserCannon.h"
#import "QuadLaserCannon.h"
#import "Arsenal.h"
#import "Shatter.h"
#import "FastLaser.h"

@implementation QPBattlefield

#pragma mark setup

static QPBattlefield *instance = nil;

+ (QPBattlefield *)f {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QPBattlefield alloc] init];
    });
    
    return instance;
}

- (void)dealloc {
    [_pilot removeFromParentAndCleanup:YES];
    self.pilot = nil;
    self.layer = nil;
    [super dealloc];
}

- (void)setupPulses {
    _pulseTimes[0] = 10;
    _pulseTimes[1] = 10;
    _pulseTimes[2] = 5;
    _pulseTimes[3] = 5;
    _breaths = 0;
    _breathCycle = 30;
    _breathFlow = 1;
}

- (void)setupPilot {
    self.pilot = [[[QuantumPilot alloc] init] autorelease];
    self.pilot.pilotDelegate = self;
    self.pilot.bulletDelegate = self;
    [self addChild:self.pilot];
    [self setupSpeeds];
}

- (void)setupStates {
    self.titleState = [[[QPBFTitleState alloc] initWithBattlefield:self] autorelease];
    self.drawingState = [[[QPBFDrawingState alloc] initWithBattlefield:self] autorelease];
    self.pausedState =  [[[QPBFPausedState alloc] initWithBattlefield:self] autorelease];
    self.fightingState = [[[QPBFFightingState alloc] initWithBattlefield:self] autorelease];
    [self changeState:self.titleState];
}

- (void)setupDeadline {
    self.dl = [[[DeadLine alloc] init] autorelease];
    [self addChild:self.dl];
}

- (void)setupWeapons {
    self.weapons = [Arsenal upgradeArsenal];
}

- (NSString *)activePath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [path stringByAppendingPathComponent:@"qp_active_skill"];
}

- (void)loadSounds {
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"dismantler" ofType:@"m4a"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &dismantler);
    
    path  = [[NSBundle mainBundle] pathForResource:@"corecrusher" ofType:@"m4a"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &corecrusher);
    
    path  = [[NSBundle mainBundle] pathForResource:@"novasplitter" ofType:@"m4a"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &novasplitter);
    
    path  = [[NSBundle mainBundle] pathForResource:@"exoslicer" ofType:@"m4a"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &exoslicer);
    
    path  = [[NSBundle mainBundle] pathForResource:@"spacemelter" ofType:@"m4a"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &spacemelter);
    path  = [[NSBundle mainBundle] pathForResource:@"gammahammer" ofType:@"m4a"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &gammahammer);
    path  = [[NSBundle mainBundle] pathForResource:@"voidwave" ofType:@"m4a"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &voidwave);

    path  = [[NSBundle mainBundle] pathForResource:@"voidwave" ofType:@"m4a"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &voidwave);

    path  = [[NSBundle mainBundle] pathForResource:@"l1-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &l1);

    path  = [[NSBundle mainBundle] pathForResource:@"l2-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &l2);

    
    path  = [[NSBundle mainBundle] pathForResource:@"l3-22" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &l3);

    
    path  = [[NSBundle mainBundle] pathForResource:@"l4" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &l4);

    path  = [[NSBundle mainBundle] pathForResource:@"l5-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &l5);

    
    path  = [[NSBundle mainBundle] pathForResource:@"l6-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &l6);

    
    path  = [[NSBundle mainBundle] pathForResource:@"l7-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &l7);

    path  = [[NSBundle mainBundle] pathForResource:@"collect-8" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &collect);

    path  = [[NSBundle mainBundle] pathForResource:@"x1-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &x1);

    path  = [[NSBundle mainBundle] pathForResource:@"x2-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &x2);
    
    path  = [[NSBundle mainBundle] pathForResource:@"x3-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &x3);
    path  = [[NSBundle mainBundle] pathForResource:@"x4-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &x4);
    path  = [[NSBundle mainBundle] pathForResource:@"x5-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &x5);
    path  = [[NSBundle mainBundle] pathForResource:@"x6-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &x6);
    path  = [[NSBundle mainBundle] pathForResource:@"x7-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &x7);
    
    path  = [[NSBundle mainBundle] pathForResource:@"process-12" ofType:@"wav"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &process);

    path  = [[NSBundle mainBundle] pathForResource:@"drag" ofType:@"m4a"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &drag);
    
    path  = [[NSBundle mainBundle] pathForResource:@"tap" ofType:@"m4a"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &tap);
    
    path  = [[NSBundle mainBundle] pathForResource:@"copy" ofType:@"m4a"];
    pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &copy);

}

- (void)createSound:(NSString *)s systemSoundID:(SystemSoundID)ssid format:(NSString *)f{
    NSString *path = [[NSBundle mainBundle] pathForResource:s ofType:f];
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &ssid);
}

- (void)setupZones {
    self.zones = [NSMutableArray array];
    self.cloneZones = [NSMutableArray array];
    
    zonesWide = (int)(ceilf(_battlefieldFrame.size.width / (50.0f)));
    zonesTall = (int)(ceilf(_battlefieldFrame.size.height / (50.0f)));
    
    for (int i = 0; i < zonesTall; i++) {
        NSMutableArray *zs = [NSMutableArray array];
        for (int ii = 0; ii < zonesWide; ii++) {
            NSMutableArray *z = [NSMutableArray array];
            [zs addObject:z];
        }
        [self.zones addObject:zs];
    }
    
    for (int i = 0; i < zonesTall; i++) {
        NSMutableArray *zs = [NSMutableArray array];
        for (int ii = 0; ii < zonesWide; ii++) {
            NSMutableArray *z = [NSMutableArray array];
            [zs addObject:z];
        }
        [self.cloneZones addObject:zs];
    }
    
    NSLog(@"wide, tall, size, count, count[0]: %d, %d, %d %d", zonesWide, zonesTall, self.zones.count, [self.zones[0] count]);
}

- (id)init {
    self = [super init];
    if (self) {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        _battlefieldFrame = CGRectMake(bounds.origin.x - 10, bounds.origin.y - 10, bounds.size.width + 10, bounds.size.height + 10);
        _screenSize = bounds.size;

        self.bullets = [NSMutableArray array];
        self.cloneBullets = [NSMutableArray array];

        [self setupZones];
        
        self.debris = [NSMutableArray array];
        self.shieldDebris = [NSMutableArray array];
        self.shatters = [NSMutableArray array];
        [self setupPulses];
        [self setupPilot];
        [self setupStates];
        [self setupClones];
        [self setupDeadline];
        [self setupSpeeds];
        [self setupWeapons];
        [self loadSounds];
        self.scoreCycler = [[[QPScoreCycler alloc] init] autorelease];
     
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(processBulletMoved:)
                                                     name:@"BulletMoved"
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(processCloneBulletMoved:)
                                                     name:@"CloneBulletMoved"
                                                   object:nil];

        
        _screenSize = [[UIScreen mainScreen] bounds].size;
        
        level = 1;
        drawRadius = 10;
        fireCircle = [self fireCircleReset];
        
        [self setupDebrisCores];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SpeedLabel" object:[NSString stringWithFormat:@"%d%%", _coreCycles]];
    }
    return self;
}

- (void)setupDebrisCores {
    NSNumber *cores = [[NSUserDefaults standardUserDefaults] objectForKey:@"cores"];
    if (cores) {
        _coresCollected = [cores intValue];
    }
    
    NSNumber *coreCycles = [[NSUserDefaults standardUserDefaults] objectForKey:@"corecycles"];
    if (coreCycles) {
        _coreCycles = [coreCycles intValue];
    }
}

- (CGPoint)fireCircleReset {
    return ccp([[UIScreen mainScreen] bounds].size.width / 2 ,28);
}

- (float)pulseRotation {
    return _breaths / _breathCycle;
}

+ (float)pulseRotation {
    return [[QPBattlefield f] pulseRotation];
}

+ (float)rhythmScale {
    QPBattlefield *battlefield = [QPBattlefield f];
    return [battlefield rhythmScale];
}

- (float)rhythmScale {
    return _rhythmScale;
}

#pragma mark Pulse

- (void)rhythmPulse {
    _pulseCharge++;
    _breaths+= _breathFlow;
    if (_pulseCharge >= _pulseTimes[_pulseState]) {
        _pulseCharge = 0;
        _pulseState++;
        if (_pulseState > 3) {
            _pulseState = 0;
            _breathFlow = -_breathFlow;
        }
    }
    
    float progress = (float)_pulseCharge / (float)_pulseTimes[_pulseState];
    switch (_pulseState) {
        case resting:
            _rhythmScale = .3;
            break;
        case holding:
            _rhythmScale = 1;
            break;
        case charging:
            _rhythmScale = .6 + progress * .5;
            break;
        case falling:
            _rhythmScale = 1.2 - progress * .6;
            break;
        default:
            break;
    }
}

#pragma mark Pacing

- (void)historiesCleared {
    [self setupClone];
}

#pragma mark Bullets

- (BOOL)bulletOutOfBounds:(Bullet *)b {
    return !CGRectContainsPoint(_battlefieldFrame, b.l);
}

- (void)eraseBullets {
    for (Bullet *b in self.bullets) {
        [self removeChild:b cleanup:YES];
    }
    for (Bullet *b in self.cloneBullets) {
        [self removeChild:b cleanup:YES];
    }
    [self.bullets removeAllObjects];
    [self.cloneBullets removeAllObjects];
    [self setupZones];
}

- (void)createDebrisFromCloneKill:(QuantumClone *)c bullet:(Bullet *)b {
//    if (self.clones.lastObject == c) {
//        return;
//    }
    
    
    Debris *d = [[[Debris alloc] initWithL:c.l] autorelease];
    [d multiplySpeed:[self speedMod]];
    [d assignLevel];
    [self addChild:d];
    [self.debris addObject:d];
    
    Shatter *s = [[[Shatter alloc] initWithL:c.l weapon:[b weapon]] autorelease];
    [self.shatters addObject:s];
    [self addChild:s];
}

- (void)playKillSound {
    int x = arc4random() % 7;
    
    switch (x) {
        case 0:
            AudioServicesPlaySystemSound(x1);
            break;
        case 1:
            AudioServicesPlaySystemSound(x2);
            break;
        case 2:
            AudioServicesPlaySystemSound(x3);
            break;
        case 3:
            AudioServicesPlaySystemSound(x4);
            break;
        case 4:
            AudioServicesPlaySystemSound(x5);
            break;
        case 5:
            AudioServicesPlaySystemSound(x6);
            break;
        case 6:
            AudioServicesPlaySystemSound(x7);
            break;
            
        default:
            break;
    }
}

- (void)processKill:(QuantumPilot *)c bullet:(Bullet *)b {
    [self playKillSound];
    if (c != self.pilot) {
        hits++;
        totalHits++;
        [self.scoreCycler score:(10000 * hits)];
        [self createDebrisFromCloneKill:(QuantumClone *)c bullet:b];
    }
}

- (void)pulseBullets:(NSMutableArray *)bs {
    NSMutableArray *bulletsToErase = [NSMutableArray array];
    for (Bullet *b in bs) {
        [b pulse];
        if ([self bulletOutOfBounds:b]) {
            [bulletsToErase addObject:b];
        }
    }
    
    for (Bullet *b in bulletsToErase) {
        shotsFired++;
        totalShotsFired++;
        if (![self bulletOutOfBounds:b]) {
            NSMutableArray *a = self.zones[b.zy][b.zx];
            [a removeObject:b];
        }
        [b removeFromParentAndCleanup:YES];
    }
    
    [bs removeObjectsInArray:bulletsToErase];
}

- (void)pulseCloneBullets:(NSMutableArray *)bs {
    NSMutableArray *bulletsToErase = [NSMutableArray array];
    for (Bullet *b in bs) {
        [b pulse];
        if ([self bulletOutOfBounds:b]) {
            [bulletsToErase addObject:b];
        }
    }
    
    for (Bullet *b in bulletsToErase) {
        if (![self bulletOutOfBounds:b]) {
            NSMutableArray *a = self.cloneZones[b.zy][b.zx];
            [a removeObject:b];
        }
        [b removeFromParentAndCleanup:YES];
    }
    
    [bs removeObjectsInArray:bulletsToErase];
}

- (void)eraseClones {
    for (QuantumClone *c in self.clones) {
        [self removeChild:c cleanup:YES];
    }
    [self.clones removeAllObjects];
}

- (void)eraseDebris {
    for (Debris *d in self.debris) {
        [self removeChild:d cleanup:YES];
    }
    [self.debris removeAllObjects];
}

- (void)resetPilot {
    [self.pilot engage];
}

- (void)resetBattlefield {
    veteran = level > 4;
    _guideMode = veteran ? circle : _guideMode;
    level = 1;
    if (_coresCollected > 53) {
        _coresCollected = 0;
        _coreCycles++;
        if (_coreCycles > 101) {
            _coreCycles = 101;
        }
    }
    NSNumber *cores = [NSNumber numberWithInteger:_coresCollected];
    [[NSUserDefaults standardUserDefaults] setObject:cores forKey:@"cores"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSNumber *coreCycles  = [NSNumber numberWithInteger:_coreCycles];
    [[NSUserDefaults standardUserDefaults] setObject:coreCycles forKey:@"corecycles"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    lastScore = [self.scoreCycler actualScore];
    [self.scoreCycler reset];
    [self eraseBullets];
    [self eraseClones];
    [self eraseDebris];
    [self resetPilot];
    [self changeState:self.titleState];
    [self setupClone];
    [self.dl reset];
    [self resetLevelScore];
    
    self.score = 0;
    [self setupSpeeds];
    weaponLevel = 0;
    installLevel = 0;
    warning = 0;
    slow = 0;
    
    _playedDrag = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SpeedLabel" object:[NSString stringWithFormat:@"%d%%", _coreCycles]];
}

- (BOOL)debrisOutOfBounds:(Debris *)d {
    return !CGRectContainsPoint(_battlefieldFrame, d.l) || [d dissipated];
}


- (void)debrisPulse {
    NSMutableArray *debrisToErase = [NSMutableArray array];
    for (Debris *d in self.debris) {
        [d pulse];

        if ([self debrisOutOfBounds:d]) {
            [debrisToErase addObject:d];         
        } else if ([self.pilot processDebris:d]) {
            AudioServicesPlaySystemSound(collect);
            
            _coresCollected++;
            
            if (self.pilot.weaponLevel == 0) {
                switch (d.level) {
                    case 0:
                        AudioServicesPlaySystemSound(dismantler);
                        break;
                    case 1:
                        AudioServicesPlaySystemSound(novasplitter);
                        break;
                    case 2:
                        AudioServicesPlaySystemSound(corecrusher);
                        break;
                    case 3:
                        AudioServicesPlaySystemSound(exoslicer);
                        break;
                    case 4:
                        AudioServicesPlaySystemSound(gammahammer);
                        break;
                    case 5:
                        AudioServicesPlaySystemSound(spacemelter);
                        break;
                    case 6:
                        AudioServicesPlaySystemSound(voidwave);
                        break;
                        
                    default:
                        break;
                }
            }
            [self.pilot announceWeapon];

            [self.scoreCycler score:100];
            [debrisToErase addObject:d];
        }
    }
    
    for (Debris *d in debrisToErase) {
        [d removeFromParentAndCleanup:YES];
    }
    
    [self.debris removeObjectsInArray:debrisToErase];
}

- (void)processPilotBulletsForZone:(NSMutableArray *)a forClone:(QuantumClone *)c {
    NSMutableArray *bulletsToRemove = [NSMutableArray array];
    for (Bullet *b in a) {
        if (ccpDistance(b.l, c.l) < 70 && [c processBullet:b]) {
            [self processKill:c bullet:b];
            [bulletsToRemove addObject:b];
        }
    }
    [a removeObjectsInArray:bulletsToRemove];
}

- (void)processPilotBullets {
    for (QuantumClone *c in self.clones) {
        if (c.active) {
            [self processPilotBulletsForZone:self.zones[c.zy][c.zx] forClone:c];
            
            bool greaterZeroX = c.zx > 0;
            bool greaterZeroY = c.zy > 0;
            bool lessMaxX = c.zx < zonesWide;
            bool lessMaxY = c.zy < zonesTall;
            if (greaterZeroX) {
                [self processPilotBulletsForZone:self.zones[c.zy][c.zx-1] forClone:c];
                if (greaterZeroY) {
                    [self processPilotBulletsForZone:self.zones[c.zy-1][c.zx-1] forClone:c];
                } else if (lessMaxY) {
                    [self processPilotBulletsForZone:self.zones[c.zy+1][c.zx-1] forClone:c];
                }
            } else if (lessMaxX) {
                [self processPilotBulletsForZone:self.zones[c.zy][c.zx+1] forClone:c];
                if (greaterZeroY) {
                    [self processPilotBulletsForZone:self.zones[c.zy-1][c.zx+1] forClone:c];
                } else if (lessMaxY) {
                    [self processPilotBulletsForZone:self.zones[c.zy+1][c.zx+1] forClone:c];
                }
            }
            
            if (lessMaxX) {
                [self processPilotBulletsForZone:self.zones[c.zy][c.zx+1] forClone:c];
            } else if (lessMaxY) {
                [self processPilotBulletsForZone:self.zones[c.zy+1][c.zx] forClone:c];
            }
        }
    }
    
    
    
    for (Bullet *b in self.bullets) {
        if (b.crushes > 0) {
            NSMutableArray *a = self.cloneZones[b.zy][b.zx];
                for (Bullet *bb in a) {
                    if (ccpDistance(b.l, bb.l) < 4) {
                        [b crushBullet:bb];
                    }
                }
        }
    }
}

- (bool)bulletCrushes:(Bullet *)b {
    return b.class == [FastLaser class];
}

- (void)processCloneBulletsInZone:(NSMutableArray *)a {
    NSMutableArray *bulletsToRemove = [NSMutableArray array];
    for (Bullet *b in a) {
        if (ccpDistance(b.l, self.pilot.l) < 70 && [self.pilot processBullet:b]) { //opportunity for dodge notation
            [self playKillSound];
            [bulletsToRemove addObject:b];
        }
    }
    
    [a removeObjectsInArray:bulletsToRemove];
}

- (void)processCloneBullets {
    [self processCloneBulletsInZone:self.cloneZones[self.pilot.zy][self.pilot.zx]];
    bool greaterZeroX = self.pilot.zx > 0;
    bool greaterZeroY = self.pilot.zy > 0;
    bool lessMaxX = self.pilot.zx < zonesWide;
    bool lessMaxY = self.pilot.zy < zonesTall;
    if (greaterZeroX) {
        [self processCloneBulletsInZone:self.cloneZones[self.pilot.zy][self.pilot.zx-1]];
        if (greaterZeroY) {
            [self processCloneBulletsInZone:self.cloneZones[self.pilot.zy-1][self.pilot.zx-1]];
        } else if (lessMaxY) {
            [self processCloneBulletsInZone:self.cloneZones[self.pilot.zy+1][self.pilot.zx-1]];
        }
    } else if (lessMaxX) {
        [self processCloneBulletsInZone:self.cloneZones[self.pilot.zy][self.pilot.zx+1]];
        if (greaterZeroY) {
            [self processCloneBulletsInZone:self.cloneZones[self.pilot.zy-1][self.pilot.zx+1]];
        } else if (lessMaxY) {
            [self processCloneBulletsInZone:self.cloneZones[self.pilot.zy+1][self.pilot.zx+1]];
        }
    }
    
    if (lessMaxX) {
        [self processCloneBulletsInZone:self.cloneZones[self.pilot.zy][self.pilot.zx+1]];
    } else if (lessMaxY) {
        [self processCloneBulletsInZone:self.cloneZones[self.pilot.zy+1][self.pilot.zx]];
    }
    
    for (Bullet *b in self.cloneBullets) {
        if (b.crushes > 0) {
            NSMutableArray *a = self.zones[b.zy][b.zx];
            for (Bullet *bb in a) {
                if (ccpDistance(b.l, bb.l) < 4) {
                    [b crushBullet:bb];
                }
            }
        }
    }
}

- (void)bulletPulse {
    [self pulseBullets:self.bullets];
    [self pulseCloneBullets:self.cloneBullets];
    
    [self processPilotBullets];
    [self processCloneBullets];
    
    if (self.pilot.active == NO) {
        [self resetBattlefield];
    }
}

- (void)clonesPulse {
    for (QuantumClone *c in self.clones) {
        if (warning) {
            [c showFireSignal];
        }
        [c pulse];
    }
}

- (void)activateClones {
    for (QuantumClone *c in self.clones) {
        [c activate];
    }
}

- (NSInteger)currentScoreBonus {
    NSDictionary *total = [self levelScore];
    NSNumber *acc = total[QP_BF_ACCSCORE];
    NSNumber *path = total[QP_BF_PATHSCORE];
    
    return [acc intValue] + [path intValue];
}

- (NSDictionary *)levelScore {
    float ab = 0;
    if (hits >= shotsFired) {
        ab = 100000;
    } else {
        float acc = (float)hits / (float)shotsFired;
        ab = floorf(acc * 10000);
    }
    
    NSNumber *accBonus = [NSNumber numberWithInteger:(int)floorf(ab)];
    
    float pathing = 0;
    if (paths <= 1) {
        pathing = 100000;
    } else if (paths < level) {
        pathing = (float)(paths - 1) / (float)level;
        pathing = fabsf(1-pathing);
        pathing *= 100000;
    }
    
    NSNumber *pathingBonus = [NSNumber numberWithFloat:pathing];
    NSNumber *currentScore = [NSNumber numberWithInteger:self.score];
    
    return @{QP_BF_ACCSCORE: accBonus, QP_BF_PATHSCORE: pathingBonus, QP_BF_SCORE: currentScore};
}

- (void)resetLevelScore {
    hits = 0;
    shotsFired = 0;
    paths = 1;
}

- (void)processWaveKill {
    AudioServicesPlaySystemSound(process);
    _recentBonus += [self currentScoreBonus];
    [self.pilot resetPosition];
    QuantumClone *c = [[self.pilot clone] copy];
    c.bulletDelegate = self;
    c.weapon = self.pilot.weapon;
    [self.clones addObject:c];
    [self addChild:c];
    [self.clones removeObject:self.pilot.clone];
    [self removeChild:self.pilot.clone cleanup:YES];
    self.pilot.clone = nil;
    [self.pilot installWeapon];
    [self activateClones];
    [self setupClone];
    [self.pilot resetIterations];
//    [self.scoreCycler addScoring:[self levelScore]];
    self.score = [self.scoreCycler actualScore];
    [self changeState:self.pausedState];
    [self resetLevelScore];
    [self eraseBullets];
    [self.dl reset];
    weaponLevel = 0;
    level++;
    if (!veteran &&level == 2) {
        [self playCopySound];
    }
    
    warning = 0;
    slow = 0;
    
    for (QuantumClone *c in self.clones) {
        c.showPath = false;
    }
    
    int i = self.clones.count - 2;
    QuantumClone *pc = self.clones[i];
    pc.showPath = true;
}

- (void)killPulse {
    if ([self activeClones] == 0) {
        [self processWaveKill];
    }
}

- (bool)isPulsing {
    return [self.currentState isPulsing];
}

- (void)moveDeadline {
    if (!slow) {
        [self.dl pulse];
    } else {
        slow--;
    }
    
    if (self.dl.y < self.pilot.l.y) {
        AudioServicesPlaySystemSound(process);
        [self resetBattlefield];
    }

}

- (void)shieldDebrisPulse {
    NSMutableArray *debrisToErase = [NSMutableArray array];
    for (ShieldDebris *d in self.shieldDebris) {
        [d pulse];
        
        if ([self debrisOutOfBounds:d]) {
            [debrisToErase addObject:d];
        }
    }
    
    for (ShieldDebris *d in debrisToErase) {
        [d removeFromParentAndCleanup:YES];
    }
    
    [self.shieldDebris removeObjectsInArray:debrisToErase];

}

- (void)shatterPulse {
    NSMutableArray *shattersToErase = [NSMutableArray array];
    for (Shatter *s in self.shatters) {
        [s pulse];
        if ([s dissipated]) {
            [shattersToErase addObject:s];
        }
    }
    
    for (Shatter *s in shattersToErase) {
        [self removeChild:s cleanup:true];
    }
    
    [self.shatters removeObjectsInArray:shattersToErase];
}

- (void)calculateCircleCharges {
    _circleCharges = [self.pilot weaponLevel];
}

- (void)pulseCircleDrawings {
    _drawings = self.currentState == self.titleState ? _coresCollected : _circleCharges;
    switch (_guideMode) {
        case circle:
            drawRadius--;
            if (drawRadius < 10) {
                if (self.currentState == self.fightingState) {
                    drawRadius = 50;
                    break;
                } else if (self.currentState == self.titleState || self.currentState == self.pausedState) {
                    
                    drawRadius = 0;
                    
                    _guideMode = zigzag;
                    
                    if (level == 1 && !veteran && !_playedDrag) {
                        [self playDragSound];
                    }
                    zigzags[0] = self.pilot.l;
                    for (int i = 1; i < 50; i++) {
                        int rx = arc4random() % 4;
                        if (arc4random() % 2 == 0) {
                            rx = -rx;
                        }
                        zigzags[i] = ccp(zigzags[i-1].x + rx, zigzags[i-1].y + 3);
                    }
                }
            }
            break;
        case zigzag:
            drawRadius++;
            if (drawRadius > 50) {
                drawRadius = 50;
                _guideMode = circle;
            }
            break;
        case fire:
            drawRadius--;
            if (drawRadius <= 1) {
                drawRadius = 20;
            }
            break;
        default:
            break;
    }
    
    if (_guideMode == zigzag) {
        
    }
}

- (void)pulse {
    [self pulseCircleDrawings];
    [self calculateCircleCharges];
    [self.currentState pulse];
    [self rhythmPulse];
    [self shieldDebrisPulse];
    [self shatterPulse];
    [self scorePulse];
    
    if ([self isPulsing]) {
        [self debrisPulse];
        [self.pilot pulse];
        [self clonesPulse];
        [self killPulse];
        [self bulletPulse];
        [self moveDeadline];
    } else {
        [self.pilot defineEdges];
        [self.pilot prepareDeltaDraw];
        for (QuantumClone *c in self.clones) {
            [c defineEdges];
        }
        
        if (self.currentState == self.titleState || self.currentState == self.pausedState) {
        } else {
            [self scorePulse];
        }
    }
}

- (void)scorePulse {
    [self.scoreCycler pulse];
    NSInteger currentScore = [self.scoreCycler displayedScore];
    NSInteger bonus = [self currentScoreBonus];
    
    [self.scoreCycler score:_recentBonus];
    _recentBonus = 0;
    
    NSString *scoreDisplay = @"";
    if (self.pilot.fightingIteration == 0) {
        scoreDisplay = [NSString stringWithFormat:@"%d", currentScore + 0];
    } else {
        NSString *bonusDisplay = bonus >= 200480 ? @"PERFECT" : [NSString stringWithFormat:@"%d", bonus];
        scoreDisplay = [NSString stringWithFormat:@"%d + %@", currentScore, bonusDisplay];
        
    }
    
    if (self.currentState == self.titleState) {
        scoreDisplay = [NSString stringWithFormat:@"%d", -lastScore];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreLabel" object:[NSString stringWithFormat:@"%@", scoreDisplay]];
}

#pragma mark States

- (void)changeState:(QPBFState *)state withOptions:(NSDictionary *)options {
    if (self.currentState) {
        [self.currentState deactivate];
    }
    
    self.currentState = state;
    [self.currentState activate:options];
}

- (void)changeState:(QPBFState *)state {
    [self changeState:state withOptions:nil];
}

- (void)changeState:(QPBFState *)state withTouch:(CGPoint)l {
    if (self.currentState == self.fightingState) {
        paths++;
        totalPaths++;
    }
    [self changeState:state];
    [self.currentState addTouch:l];
}

#pragma mark Input

- (void)addTouch:(CGPoint)l {
    [self.currentState addTouch:l];
}

- (void)addDoubleTouch {
    [self.currentState addDoubleTouch];
}

- (void)endTouch:(CGPoint)l {
    [self.currentState endTouch:l];
}

- (void)moveTouch:(CGPoint)l {
    [self.currentState moveTouch:l];
}

#pragma mark Pilot Positioning

- (BOOL)touchingPlayer:(CGPoint)l {
    return GetDistance(l, self.pilot.l) <= QPBF_PLAYER_TAP_RANGE;
}

- (CGPoint)playerTouchWithOffset {
    return CombinedPoint(self.playerTouch, self.touchOffset);
}

- (void)setTouchOffsetFromPilotNear:(CGPoint)l {
    self.touchOffset = ccp(self.pilot.l.x - l.x, self.pilot.l.y - l.y);
}

- (void)setTouchOffsetFromLatestExpectedNear:(CGPoint)l {
    self.touchOffset = ccp(self.latestExpected.x - l.x, self.latestExpected.y - l.y);
}

#pragma mark deltas

#pragma mark Pilot Delgate

- (void)pilotReachedEndOfFutureWaypoints {
}

#pragma mark Bullet Delegate

- (void)playBulletSound:(int)li {
    switch (li) {
        case 0:
            AudioServicesPlaySystemSound(l1);
            break;
        case 1:
            AudioServicesPlaySystemSound(l2);
            break;
        case 2:
            AudioServicesPlaySystemSound(l3);
            break;
        case 3:
            AudioServicesPlaySystemSound(l4);
            break;
        case 4:
            AudioServicesPlaySystemSound(l5);
            break;
        case 5:
            AudioServicesPlaySystemSound(l6);
            break;
        case 6:
            AudioServicesPlaySystemSound(l7);
            break;
            
        default:
            break;
    }
}

- (void)bulletsFired:(NSArray *)bullets li:(int)li {
    [self playBulletSound:li];
    
    for (Bullet *b in bullets) {
        [self addChild:b];
        b.tag = -1;
        b.delegate = self;

        
        NSMutableArray *a = self.zones[b.zy][b.zx];
        [a addObject:b];
    }
    
    [self.bullets addObjectsFromArray:bullets];
    [self.scoreCycler score:1];
}

- (void)cloneBulletsFired:(NSArray *)bullets li:(int)li {
    [self playBulletSound:li];
    for (Bullet *b in bullets) {
        [self addChild:b];
        b.tag = 0;
        b.delegate = self;
        
        NSMutableArray *a = self.cloneZones[b.zy][b.zx];
        [a addObject:b];
    }
    
    [self.cloneBullets addObjectsFromArray:bullets];
}

#pragma mark Clones

- (void)setupClone {
    [self.pilot createClone];
    [self.clones addObject:self.pilot.clone];
    [self addChild:(CCNode *)self.pilot.clone];
}

- (NSInteger)activeClones {
    NSInteger active = 0;
    for (QuantumClone *c in self.clones) {
        active += c.active ? 1 : 0;
    }
    return active;
}

- (void)setupClones {
    self.clones = [NSMutableArray array];
    [self setupClone];
}

#pragma mark Speeds

- (void)setupSpeeds {
    [self generateSpeedMod];
    float speed = 1.6f + (float)((arc4random() % 50) * 0.01f);
    [self.pilot setSpeed:speed * [self speedMod]];
    
    [self.dl reset];
    self.dl.speed *= [self speedMod];
}

#pragma mark Pilot effects

- (void)draw {
    [super draw];
    
    [[Arsenal weaponIndexedFromArsenal:[self.pilot arsenalLevel]] setDrawColor];
    
    float x = (_screenSize.width / 2 - ((float)_drawings * (float)3));
    
    if (self.currentState == self.titleState) {
        if (_drawings > 0) {
            for (int i = 0; i < _drawings + 1; i++) {
                CGPoint c = ccp(x, 28);
                ccDrawFilledCircle(c, 1.7, 0, 30, NO);
                x+=6;
            }
        }
    } else {
        for (int i = 0; i < _drawings + 1; i++) {
            CGPoint c = ccp(x, 28);
            ccDrawFilledCircle(c, 1.7, 0, 30, NO);
            x+=6;
        }
    }

    switch (_guideMode) {
        case circle:
            ccDrawCircle(self.pilot.l, drawRadius, 0, 50, 0);
            break;
        case zigzag:
            ccDrawPoly(zigzags, drawRadius, 0);
            break;
        case fire:
            ccDrawCircle(fireCircle, drawRadius, 0, 30, 0);
            break;
        default:
            break;
    }
}

- (float)bulletSpeed {
    float s = _bulletSpeed +  (min((float)_circleCharges, (float)6) * .40);
    return s * [self speedMod];
}

- (void)playDragSound {
    _playedDrag = true;
    AudioServicesPlaySystemSound(drag);
}
- (void)playTapSound {
    if (level == 1 && self.pilot.time == 2 && !veteran) {
        AudioServicesPlaySystemSound(tap);
    }
}
- (void)playCopySound {
    AudioServicesPlaySystemSound(copy);
}

- (void)generateSpeedMod {
    _bulletSpeed = 1.8f + (float)((arc4random() % 250) * 0.01f);
    if (_coreCycles > 0) {
        _speedMod = 0.4f + (0.006f * (arc4random() % _coreCycles));
        NSLog(@"speedmod: %f", _speedMod);
        return;
    }
    
    _speedMod = 0.4f;
    NSLog(@"speedmod: %f", _speedMod);
}

- (float)speedMod {
    return _speedMod;
}

- (void)bulletChangedZone:(Bullet *)b {
    if (b.zone) {
        NSMutableArray *a = self.zones[b.zy][b.zx];
        [a removeObject:b];
    }
    
    if ([self bulletOutOfBounds:b]) {
        return;
    }
    
    NSMutableArray *a = self.zones[b.zy][b.zx];
    [a addObject:b];
}

- (void)cloneBulletChangedZone:(Bullet *)b {
    if (b.zone) {
        NSMutableArray *a = self.cloneZones[b.zy][b.zx];
        [a removeObject:b];
    }

    if ([self bulletOutOfBounds:b]) {
        return;
    }
    
    NSMutableArray *a = self.cloneZones[b.zy][b.zx];
    [a addObject:b];
}

#pragma mark State Control

- (void)showCircleGuideMode {
    if (!veteran) {
        _guideMode = circle;
    }
}

- (void)resetGuideMode {
    if (!veteran && level < 4) {
        _guideMode = fire;
    } else {
        _guideMode = rest;
    }
}

- (void)restGuideMode {
    _guideMode = rest;
}

- (void)resetFireCircle {
    fireCircle = [self fireCircleReset];
}

- (void)moveFireCircleOffscreen {
    fireCircle = ccp(5000,5000);
}

- (void)resetScoringTotals {
    totalShotsFired = 0;
    totalHits = 0;
    totalPaths = 0;
}

@end
