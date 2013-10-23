//
//  QCMRadialDirector.m
//  QuadCurveMenu
//
//  Created by Franklin Webber on 3/30/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMRadialDirector.h"

static CGFloat const kQCMMenuDefaultNearRadius = 110.0;
static CGFloat const kQCMMenuDefaultEndRadius = 120.0;
static CGFloat const kQCMMenuDefaultFarRadius = 140.0;
static CGFloat const kQCMMenuDefaultTimeOffset = 0.036;
static CGFloat const kQCMMenuDefaultRotateAngle = 0.0;
static CGFloat const kQCMMenuDefaultMenuWholeAngle = M_PI * 2;

static CGPoint RotateCGPointAroundCenter(CGPoint point, CGPoint center, CGFloat angle)
{
    CGAffineTransform translation = CGAffineTransformMakeTranslation(center.x, center.y);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation);
    return CGPointApplyAffineTransform(point, transformGroup);    
}

@implementation QCMRadialDirector

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
        self.nearRadius = kQCMMenuDefaultNearRadius;
        self.endRadius = kQCMMenuDefaultEndRadius;
        self.farRadius = kQCMMenuDefaultFarRadius;
        
        self.rotateAngle = rotateAngle;
        self.menuWholeAngle = menuWholeAngle;
        
        self.useWholeAngle = [self determineIfItIsBestToUseWholeAngle];

    }
    return self;
}

- (id)initWithMenuWholeAngle:(CGFloat)menuWholeAngle {
    return [self initWithMenuWholeAngle:menuWholeAngle 
                     andInitialRotation:kQCMMenuDefaultRotateAngle];
}

- (id)init {
    return [self initWithMenuWholeAngle:kQCMMenuDefaultMenuWholeAngle 
                     andInitialRotation:kQCMMenuDefaultRotateAngle];
}

+ (instancetype)director {
	return [[self alloc] init];
}

+ (instancetype)directorWithMenuWholeAngle:(CGFloat)menuWholeAngle {
	return [[self alloc] initWithMenuWholeAngle:menuWholeAngle];
}

+ (instancetype)directorWithMenuWholeAngle:(CGFloat)menuWholeAngle andInitialRotation:(CGFloat)rotateAngle {
	return [[self alloc] initWithMenuWholeAngle:menuWholeAngle andInitialRotation:rotateAngle];
}

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

- (CGFloat)threeHundredSixtyDegrees {
    return M_PI * 2;
}

#pragma mark - QCMMotionDirector Adherence

- (void)positionMenuItem:(QCMMenuItem *)item atIndex:(NSUInteger)index ofCount:(NSUInteger)count fromMenu:(QCMMenuItem *)mainMenuItem {
    
    CGPoint startPoint = mainMenuItem.center;
    item.startPoint = startPoint;
    
    CGFloat itemAngle = index * self.menuWholeAngle / (self.useWholeAngle ? count - 1 : count);
    CGFloat xCoefficient = sinf(itemAngle);
    CGFloat yCoefficient = cosf(itemAngle);
    
    CGPoint endPoint = CGPointMake(startPoint.x + self.endRadius * xCoefficient, startPoint.y - self.endRadius * yCoefficient);
    
    item.endPoint = RotateCGPointAroundCenter(endPoint, startPoint, self.rotateAngle);
    
    CGPoint nearPoint = CGPointMake(startPoint.x + self.nearRadius * xCoefficient, startPoint.y - self.nearRadius * yCoefficient);
    
    item.nearPoint = RotateCGPointAroundCenter(nearPoint, startPoint, self.rotateAngle);
    
    CGPoint farPoint = CGPointMake(startPoint.x + self.farRadius * xCoefficient, startPoint.y - self.farRadius * yCoefficient);
    
    item.farPoint = RotateCGPointAroundCenter(farPoint, startPoint, self.rotateAngle);

}

@end
