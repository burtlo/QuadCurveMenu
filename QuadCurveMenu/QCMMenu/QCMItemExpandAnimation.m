//
//  QCMItemExpandAnimation.m
//  Nudge
//
//  Created by Franklin Webber on 3/16/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMItemExpandAnimation.h"

static CGFloat const kQCMDefaultRotation = M_PI * 2;

NSString * const kQCMItemExpandAnimationItemKey = @"QCMItemExpandAnimationItem";

@implementation QCMItemExpandAnimation

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
	return @"Expand";
}

- (CAAnimationGroup *)animationForItem:(QCMMenuItem *)item {
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	positionAnimation.duration = self.duration;
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
	CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
	CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y); 
	CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y); 
	positionAnimation.path = path;
	CGPathRelease(path);
	
	NSMutableArray *animations = [NSMutableArray arrayWithObject:positionAnimation];
	
	if (self.animatesRotation) {
		CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
		rotateAnimation.values = @[[NSNumber numberWithFloat:M_PI], @0.0];
		rotateAnimation.duration = self.duration;
		rotateAnimation.keyTimes = @[@0.3, @0.4];
		[animations addObject:rotateAnimation];
	}
	
	if (self.animatesOpacity) {
		CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
		opacityAnimation.values = @[@0.0, @1.0];
		opacityAnimation.duration = self.duration;
		opacityAnimation.keyTimes = @[@0.0, @0.25];
		[animations addObject:opacityAnimation];
	}
	
	CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.animations = animations;
	animationGroup.duration = self.duration;
	animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

	animationGroup.delegate = self;
	
	[animationGroup setValue:item forKey:kQCMItemExpandAnimationItemKey];
	
	return animationGroup;
}

- (void)animationDidStart:(CAAnimation *)animationGroup {
	QCMMenuItem *item = [animationGroup valueForKey:kQCMItemExpandAnimationItemKey];
	item.hidden = NO;
}

- (void)animationDidStop:(CAAnimation *)animationGroup finished:(BOOL)finished {
	[animationGroup setValue:nil forKey:kQCMItemExpandAnimationItemKey];
}

@end
