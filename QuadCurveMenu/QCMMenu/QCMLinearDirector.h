//
//  QCMLinearDirector.h
//  QuadCurveMenu
//
//  Created by Franklin Webber on 3/30/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCMMotionDirector.h"

@interface QCMLinearDirector : NSObject <QCMMotionDirector>

- (id)init;
+ (instancetype)director;

- (id)initWithAngle:(CGFloat)angle andPadding:(CGFloat)padding;
+ (instancetype)directorWithAngle:(CGFloat)angle andPadding:(CGFloat)padding;

@property (readwrite, assign, nonatomic) CGFloat angle;
@property (readwrite, assign, nonatomic) CGFloat padding;

@end
