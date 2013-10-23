//
//  QuadCurveRadialDirector.h
//  AwesomeMenu
//
//  Created by Franklin Webber on 3/30/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuadCurveMotionDirector.h"

@interface QuadCurveRadialDirector : NSObject <QuadCurveMotionDirector>

@property (readwrite, assign, nonatomic) CGFloat nearRadius;
@property (readwrite, assign, nonatomic) CGFloat endRadius;
@property (readwrite, assign, nonatomic) CGFloat farRadius;
@property (readwrite, assign, nonatomic) CGFloat rotateAngle;
@property (readwrite, assign, nonatomic) CGFloat menuWholeAngle;
@property (readwrite, assign, nonatomic) BOOL useWholeAngle;

- (id)init;
- (id)initWithMenuWholeAngle:(CGFloat)menuWholeAngle;
- (id)initWithMenuWholeAngle:(CGFloat)menuWholeAngle andInitialRotation:(CGFloat)rotateAngle;

+ (instancetype)director;
+ (instancetype)directorWithMenuWholeAngle:(CGFloat)menuWholeAngle;
+ (instancetype)directorWithMenuWholeAngle:(CGFloat)menuWholeAngle andInitialRotation:(CGFloat)rotateAngle;

@end
