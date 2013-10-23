//
//  QCMTiltAnimation.m
//  QuadCurveMenu
//
//  Created by Franklin Webber on 4/2/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMTiltAnimation.h"

@implementation QCMTiltAnimation

@synthesize delayBetweenItemAnimation;
@synthesize duration;

#pragma mark - Initialization

- (id)initWithTilt:(CGFloat)tiltDirection {
    self = [super init];
    if (self) {
        self.tiltDirection = tiltDirection;
    }
    return self;
}

- (id)initWithClockwiseTilt {
    return [self initWithTilt:M_PI_4];
}

- (id)initWithCounterClockwiseTilt {
    return [self initWithTilt:-M_PI_4];
}

#pragma mark - QCMAnanimation Adherence

- (NSString *)animationName {
    return @"tiltAnimation";
}

- (CAAnimationGroup *)animationForItem:(QCMMenuItem *)item {
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = [[item.layer presentationLayer] valueForKeyPath:@"transform.rotation.z"];
    rotateAnimation.toValue = @(self.tiltDirection);
    rotateAnimation.duration = self.duration;
    rotateAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[rotateAnimation];
    animationGroup.duration = self.duration;
    animationGroup.fillMode = kCAFillModeForwards;
    
    item.transform = CGAffineTransformMakeRotation(self.tiltDirection);
    
    return animationGroup;
}

@end
