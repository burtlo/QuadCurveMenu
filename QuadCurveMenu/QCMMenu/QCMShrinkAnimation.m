//
//  QCMShrinkAnimation.m
//  Nudge
//
//  Created by Franklin Webber on 3/16/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMShrinkAnimation.h"

static CGFloat const kQCMDefaultShrinkScale = 0.1;

@implementation QCMShrinkAnimation

@synthesize duration;
@synthesize delayBetweenItemAnimation;

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.shrinkScale = kQCMDefaultShrinkScale;
        self.delayBetweenItemAnimation = kQuadCoreDefaultDelayBetweenItemAnimation;
    }
    return self;
}


#pragma mark - QCMAnimation Adherence

- (NSString *)animationName {
    return @"shrink";
}

- (CAAnimationGroup *)animationForItem:(QCMMenuItem *)item {
    
    CGPoint point = item.center;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:point];
    positionAnimation.toValue = [NSValue valueWithCGPoint:point];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.shrinkScale, self.shrinkScale, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = @0.0;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation, scaleAnimation, opacityAnimation];
    animationGroup.duration = self.duration;
    animationGroup.fillMode = kCAFillModeForwards;

    [item performSelector:@selector(setHidden:) withObject:@(YES) afterDelay:self.duration];

    return animationGroup;
}

@end
