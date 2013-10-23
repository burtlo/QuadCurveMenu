//
//  QCMNoAnimation.m
//  QuadCurveMenu
//
//  Created by Franklin Webber on 5/28/13.
//
//

#import "QCMNoAnimation.h"

@implementation QCMNoAnimation

@synthesize duration;
@synthesize delayBetweenItemAnimation;

- (NSString *)animationName {
    return @"NoAnimation";
}

- (CAAnimationGroup *)animationForItem:(QCMMenuItem *)item {
    return [CAAnimationGroup animation];
}

@end
