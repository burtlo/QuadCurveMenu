//
//  QuadCurveAnimation.h
//  Nudge
//
//  Created by Franklin Webber on 3/16/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "QuadCurveMenuItem.h"

static CGFloat const kQuadCoreDefaultAnimationDuration = 0.5;
static CGFloat const kQuadCoreDefaultDelayBetweenItemAnimation = 0.036;

@protocol QuadCurveAnimation <NSObject>

- (NSString *)animationName;
- (CAAnimationGroup *)animationForItem:(QuadCurveMenuItem *)item;

@property (readwrite, assign, nonatomic) CGFloat duration;
@property (readwrite, assign, nonatomic) CGFloat delayBetweenItemAnimation;

@end
