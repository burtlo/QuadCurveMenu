//
//  QuadCurveBlowupAnimation.m
//  Nudge
//
//  Created by Franklin Webber on 3/16/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveBlowupAnimation.h"

static CGFloat const kQuadCurveDefaultBlowUpScale = 3.0;

@implementation QuadCurveBlowupAnimation

@synthesize blowUpScale;
@synthesize duration;
@synthesize delayBetweenItemAnimation;

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.blowUpScale = kQuadCurveDefaultBlowUpScale;
        self.duration = kQuadCoreDefaultAnimationDuration;
        self.delayBetweenItemAnimation = kQuadCoreDefaultDelayBetweenItemAnimation;
    }
    return self;
}

#pragma mark - QuadCurveAnimation Adherence

- (NSString *)animationName {
    return @"blowup";
}

- (CAAnimationGroup *)animationForItem:(QuadCurveMenuItem *)item {
    
    CGPoint point = item.center;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:point];
    positionAnimation.toValue = [NSValue valueWithCGPoint:point];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.blowUpScale, self.blowUpScale, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = @0.0;
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = @[positionAnimation, scaleAnimation, opacityAnimation];
    animationgroup.duration = self.duration;
    animationgroup.fillMode = kCAFillModeForwards;

    [item performSelector:@selector(setHidden:) withObject:@(YES) afterDelay:self.duration];

    return animationgroup;
}

@end
