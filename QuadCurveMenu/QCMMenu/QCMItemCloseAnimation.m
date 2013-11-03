//
//  QCMItemCloseAnimation.m
//  Nudge
//
//  Created by Franklin Webber on 3/16/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMItemCloseAnimation.h"

static CGFloat const kQCMDefaultRotation = M_PI * 2;

NSString * const kQCMItemCloseAnimationItemKey = @"QCMItemCloseAnimationItem";

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
		self.animatesRotation = YES;
		self.animatesOpacity = YES;
	}
	return self;
}

#pragma mark - QCMAnimation Adherence


- (NSString *)animationName {
	return @"Close";
}

- (CAAnimationGroup *)animationForItem:(QCMMenuItem *)item {
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	positionAnimation.duration = self.duration;
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
	CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
	CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
	positionAnimation.path = path;
	CGPathRelease(path);
	
	NSMutableArray *animations = [NSMutableArray arrayWithObject:positionAnimation];
	
	if (self.animatesRotation) {
		CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
		rotateAnimation.values = @[@0.0, @(self.rotation), @0.0];
		rotateAnimation.duration = 0.5;
		rotateAnimation.keyTimes = @[@0.0, @0.4, @0.5];
		[animations addObject:rotateAnimation];
	}
	
	if (self.animatesOpacity) {
		CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
		opacityAnimation.values = @[@1.0, @0.0];
		opacityAnimation.duration = self.duration;
		opacityAnimation.keyTimes = @[@0.75, @1.0];
		[animations addObject:opacityAnimation];
	}
	
	CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.animations = animations;
	animationGroup.duration = self.duration;
	animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	animationGroup.delegate = self;
	
	[animationGroup setValue:item forKey:kQCMItemCloseAnimationItemKey];
	
	return animationGroup;
}

- (void)animationDidStart:(CAAnimation *)animationGroup {
	
}

- (void)animationDidStop:(CAAnimation *)animationGroup finished:(BOOL)finished {
	QCMMenuItem *item = [animationGroup valueForKey:kQCMItemCloseAnimationItemKey];
	item.hidden = YES;
	if (self.removesItemWhenDone) {
		[item removeFromSuperview];
	}
	[animationGroup setValue:nil forKey:kQCMItemCloseAnimationItemKey];
}

@end
