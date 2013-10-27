//
//  QCMItemCloseAnimation.m
//  Nudge
//
//  Created by Franklin Webber on 3/16/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMItemCloseAnimation.h"

static CGFloat const kQCMDefaultRotation = M_PI * 2;

@implementation QCMItemCloseAnimation

@synthesize duration;
@synthesize rotation;
@synthesize delayBetweenItemAnimation;

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.rotation = kQCMDefaultRotation;
        self.duration = kQuadCoreDefaultAnimationDuration;
        self.delayBetweenItemAnimation = kQuadCoreDefaultDelayBetweenItemAnimation;
    }
    return self;
}

#pragma mark - QCMAnimation Adherence


- (NSString *)animationName {
    return @"Close";
}

- (CAAnimationGroup *)animationForItem:(QCMMenuItem *)item {
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = @[@0.0, @(self.rotation), @0.0];
    rotateAnimation.duration = 0.5;
    rotateAnimation.keyTimes = @[@0.0, @0.4, @0.5];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = self.duration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y); 
    positionAnimation.path = path;
    CGPathRelease(path);
    
	CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@1.0, @0.0];
    opacityAnimation.duration = self.duration;
    opacityAnimation.keyTimes = @[@0.75, @1.0];
	
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation, rotateAnimation, opacityAnimation];
    animationGroup.duration = self.duration;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [item performSelector:@selector(setHidden:) withObject:@(YES) afterDelay:self.duration];

    return animationGroup;
}

@end
