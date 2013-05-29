//
//  QuadCurveNoAnimation.m
//  AwesomeMenu
//
//  Created by Franklin Webber on 5/28/13.
//
//

#import "QuadCurveNoAnimation.h"

@implementation QuadCurveNoAnimation

@synthesize duration;
@synthesize delayBetweenItemAnimation;

- (NSString *)animationName {
    return @"NoAnimation";
}

- (CAAnimationGroup *)animationForItem:(QuadCurveMenuItem *)item {
    return [CAAnimationGroup animation];
}

@end
