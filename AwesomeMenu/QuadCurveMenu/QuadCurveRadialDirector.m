//
//  QuadCurveRadialDirector.m
//  AwesomeMenu
//
//  Created by Franklin Webber on 3/30/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveRadialDirector.h"

static CGFloat const kQuadCurveMenuDefaultNearRadius = 110.0f;
static CGFloat const kQuadCurveMenuDefaultEndRadius = 120.0f;
static CGFloat const kQuadCurveMenuDefaultFarRadius = 140.0f;
static CGFloat const kQuadCurveMenuDefaultTimeOffset = 0.036f;
static CGFloat const kQuadCurveMenuDefaultRotateAngle = 0.0;
static CGFloat const kQuadCurveMenuDefaultMenuWholeAngle = M_PI * 2;

static CGPoint RotateCGPointAroundCenter(CGPoint point, CGPoint center, float angle)
{
    CGAffineTransform translation = CGAffineTransformMakeTranslation(center.x, center.y);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation);
    return CGPointApplyAffineTransform(point, transformGroup);    
}

@implementation QuadCurveRadialDirector

@synthesize nearRadius = nearRadius_; 
@synthesize endRadius = endRadius_;
@synthesize farRadius = farRadius_;
@synthesize rotateAngle = rotateAngle_;
@synthesize menuWholeAngle = menuWholeAngle_;
@synthesize useWholeAngle = useWholeAngle_;

#pragma mark - Initialization

- (id)initWithMenuWholeAngle:(CGFloat)menuWholeAngle 
          andInitialRotation:(CGFloat)rotateAngle {
    
    self = [super init];
    if (self) {
        self.nearRadius = kQuadCurveMenuDefaultNearRadius;
        self.endRadius = kQuadCurveMenuDefaultEndRadius;
        self.farRadius = kQuadCurveMenuDefaultFarRadius;
        
        self.rotateAngle = rotateAngle;
        self.menuWholeAngle = menuWholeAngle;
        
        self.useWholeAngle = [self determineIfItIsBestToUseWholeAngle];

    }
    return self;
}

- (id)initWithMenuWholeAngle:(CGFloat)menuWholeAngle {
    return [self initWithMenuWholeAngle:menuWholeAngle 
                     andInitialRotation:kQuadCurveMenuDefaultRotateAngle];
}

- (id)init {
    return [self initWithMenuWholeAngle:kQuadCurveMenuDefaultMenuWholeAngle 
                     andInitialRotation:kQuadCurveMenuDefaultRotateAngle];
}

+ (instancetype)directorWithMenuWholeAngle:(CGFloat)menuWholeAngle;
+ (instancetype)directorWithMenuWholeAngle:(CGFloat)menuWholeAngle andInitialRotation:(CGFloat)rotateAngle;

#pragma mark - Helper

//
// When the angle is 360 degrees, M_PI * 2, we do not want to use the entire 360 degrees
// becaues the last element will overlap with the first element. However, when we are
// less than 360 degrees we probably want to use the entire angle (e.g. 180) as there is
// no overlap.
//
// This can be overriden by setting the propery useWholeAngle
//
- (BOOL)determineIfItIsBestToUseWholeAngle {
    if (self.menuWholeAngle == [self threeHundredSixtyDegrees]) {
        return NO;
    } else {
        return YES;
    }
}

- (float)threeHundredSixtyDegrees {
    return M_PI * 2;
}

#pragma mark - QuadCurveMotionDirector Adherence

- (void)positionMenuItem:(QuadCurveMenuItem *)item atIndex:(int)index ofCount:(int)count fromMenu:(QuadCurveMenuItem *)mainMenuItem {
    
    CGPoint startPoint = mainMenuItem.center;
    item.startPoint = startPoint;
    
    float itemAngle = index * self.menuWholeAngle / (self.useWholeAngle ? count - 1 : count);
    float xCoefficient = sinf(itemAngle);
    float yCoefficient = cosf(itemAngle);
    
    CGPoint endPoint = CGPointMake(startPoint.x + self.endRadius * xCoefficient, startPoint.y - self.endRadius * yCoefficient);
    
    item.endPoint = RotateCGPointAroundCenter(endPoint, startPoint, self.rotateAngle);
    
    CGPoint nearPoint = CGPointMake(startPoint.x + self.nearRadius * xCoefficient, startPoint.y - self.nearRadius * yCoefficient);
    
    item.nearPoint = RotateCGPointAroundCenter(nearPoint, startPoint, self.rotateAngle);
    
    CGPoint farPoint = CGPointMake(startPoint.x + self.farRadius * xCoefficient, startPoint.y - self.farRadius * yCoefficient);
    
    item.farPoint = RotateCGPointAroundCenter(farPoint, startPoint, self.rotateAngle);

}

@end
