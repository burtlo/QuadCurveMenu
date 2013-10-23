//
//  QCMTiltAnimation.h
//  QuadCurveMenu
//
//  Created by Franklin Webber on 4/2/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMAnimation.h"

@interface QCMTiltAnimation : NSObject <QCMAnimation>

@property (readwrite, assign, nonatomic) CGFloat tiltDirection;

- (id)initWithTilt:(CGFloat)tiltDirection;
- (id)initWithClockwiseTilt;
- (id)initWithCounterClockwiseTilt;

@end
