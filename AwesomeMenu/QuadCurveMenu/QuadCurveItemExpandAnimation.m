//
//  QuadCurveItemExpandAnimation.m
//  Nudge
//
//  Created by Franklin Webber on 3/16/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveItemExpandAnimation.h"

static CGFloat const kQuadCurveDefaultRotation = M_PI * 2;

@implementation QuadCurveItemExpandAnimation

@synthesize duration;
@synthesize rotation;
@synthesize delayBetweenItemAnimation;

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.rotation = kQuadCurveDefaultRotation;
        self.duration = kQuadCoreDefaultAnimationDuration;
        self.delayBetweenItemAnimation = kQuadCoreDefaultDelayBetweenItemAnimation;
    }
    return self;
}

#pragma mark - QuadCurveAnimation Adherence


- (NSString *)animationName {
    return @"Expand";
}

- (CAAnimationGroup *)animationForItem:(QuadCurveMenuItem *)item {
    item.hidden = NO;
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = @[[NSNumber numberWithFloat:M_PI],@0.0];
    rotateAnimation.duration = self.duration;
    rotateAnimation.keyTimes = @[@.3, 
                                @.4]; 
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = self.duration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y); 
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y); 
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation, rotateAnimation];
    animationGroup.duration = self.duration;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    return animationGroup;
}


@end
