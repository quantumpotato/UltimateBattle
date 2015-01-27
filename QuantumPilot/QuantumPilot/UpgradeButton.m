//
//  UpgradeButton.m
//  QuantumPilot
//
//  Created by quantum on 22/01/2015.
//
//

#import "UpgradeButton.h"

@implementation UpgradeButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = true;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:20];
    [self addSubview:self.label];
    [self setupNotifications];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upgrade)]];
    self.backgroundColor = [UIColor redColor];
    return self;
}

- (NSString *)updateNotificationName {
    return nil;
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLabel:)
                                                 name:[self updateNotificationName]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hide)
                                                 name:@"clearLabels"
                                               object:nil];
    
}

- (void)hide {
//    self.alpha = 0;
}

- (void)upgrade {
    //alert battlefield
}

- (void)updateLabel:(NSNotification *)n {
    [self.superview bringSubviewToFront:self];
    self.alpha = 1;
    self.label.text = n.object;
}

@end