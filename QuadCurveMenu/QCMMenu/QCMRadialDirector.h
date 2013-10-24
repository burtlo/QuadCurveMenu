//
//  QCMRadialDirector.h
//  QuadCurveMenu
//
//  Created by Franklin Webber on 3/30/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCMMotionDirector.h"

@interface QCMRadialDirector : NSObject <QCMMotionDirector>

@property (readwrite, assign, nonatomic) CGFloat radius;
@property (readwrite, assign, nonatomic) CGFloat nearRadiusFactor;
@property (readwrite, assign, nonatomic) CGFloat farRadiusFactor;

@property (readwrite, assign, nonatomic) CGFloat startAngle;
@property (readwrite, assign, nonatomic) CGFloat arcAngle;

- (id)init;
- (id)initWithArcAngle:(CGFloat)arcAngle;
- (id)initWithArcAngle:(CGFloat)arcAngle startAngle:(CGFloat)startAngle;

+ (instancetype)director;
+ (instancetype)directorWithArcAngle:(CGFloat)arcAngle;
+ (instancetype)directorWithArcAngle:(CGFloat)arcAngle startAngle:(CGFloat)startAngle;

+ (CGFloat)defaultRadius;
+ (CGFloat)defaultNearRadiusFactor;
+ (CGFloat)defaultFarRadiusFactor;

+ (CGFloat)defaultArcAngle;
+ (CGFloat)defaultStartAngle;

@end
