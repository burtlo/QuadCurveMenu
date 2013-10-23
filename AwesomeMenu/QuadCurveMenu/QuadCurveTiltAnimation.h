//
//  QuadCurveTiltAnimation.h
//  AwesomeMenu
//
//  Created by Franklin Webber on 4/2/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveAnimation.h"

@interface QuadCurveTiltAnimation : NSObject <QuadCurveAnimation>

@property (readwrite, assign, nonatomic) CGFloat tiltDirection;

- (id)initWithTilt:(CGFloat)tiltDirection;
- (id)initWithClockwiseTilt;
- (id)initWithCounterClockwiseTilt;

@end
