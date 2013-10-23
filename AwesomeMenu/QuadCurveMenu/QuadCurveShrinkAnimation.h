//
//  QuadCurveShrinkAnimation.h
//  Nudge
//
//  Created by Franklin Webber on 3/16/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveAnimation.h"

@interface QuadCurveShrinkAnimation : NSObject <QuadCurveAnimation>

@property (readwrite, assign, nonatomic) CGFloat shrinkScale;

@end
