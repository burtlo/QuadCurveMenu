//
//  QCMAnimation.h
//  Nudge
//
//  Created by Franklin Webber on 3/16/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "QCMMenuItem.h"

static CGFloat const kQuadCoreDefaultAnimationDuration = 0.5;
static CGFloat const kQuadCoreDefaultDelayBetweenItemAnimation = 0.036;

@protocol QCMAnimation <NSObject>

@property (readwrite, assign, nonatomic) CGFloat duration;
@property (readwrite, assign, nonatomic) CGFloat delayBetweenItemAnimation;

- (NSString *)animationName;
- (CAAnimationGroup *)animationForItem:(QCMMenuItem *)item;

@end
