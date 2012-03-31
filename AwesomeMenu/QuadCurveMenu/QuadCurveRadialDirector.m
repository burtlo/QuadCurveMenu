//
//  QuadCurveRadialDirector.m
//  AwesomeMenu
//
//  Created by Franklin Webber on 3/30/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "QuadCurveRadialDirector.h"

static CGFloat const kQuadCurveMenuDefaultNearRadius = 110.0f;
static CGFloat const kQuadCurveMenuDefaultEndRadius = 120.0f;
static CGFloat const kQuadCurveMenuDefaultFarRadius = 140.0f;
static CGFloat const kQuadCurveMenuDefaultStartPointX = 160.0;
static CGFloat const kQuadCurveMenuDefaultStartPointY = 240.0;
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

@synthesize nearRadius; 
@synthesize endRadius;
@synthesize farRadius;
@synthesize timeOffset;
@synthesize rotateAngle;
@synthesize menuWholeAngle;
@synthesize startPoint;

- (id)init {
    self = [super init];
    
    if (self) {
        
        self.nearRadius = kQuadCurveMenuDefaultNearRadius;
        self.endRadius = kQuadCurveMenuDefaultEndRadius;
        self.farRadius = kQuadCurveMenuDefaultFarRadius;
        self.timeOffset = kQuadCurveMenuDefaultTimeOffset;
        self.rotateAngle = kQuadCurveMenuDefaultRotateAngle;
		self.menuWholeAngle = kQuadCurveMenuDefaultMenuWholeAngle;
        self.startPoint = CGPointMake(kQuadCurveMenuDefaultStartPointX, kQuadCurveMenuDefaultStartPointY);
        

    }
    return self;
}

#pragma mark - QuadCurveMotionDirector Adherence

- (void)positionMenuItem:(QuadCurveMenuItem *)item atIndex:(int)index ofCount:(int)count {
    
    item.startPoint = startPoint;
    CGPoint endPoint = CGPointMake(startPoint.x + endRadius * sinf(index * menuWholeAngle / count), startPoint.y - endRadius * cosf(index * menuWholeAngle / count));
    item.endPoint = RotateCGPointAroundCenter(endPoint, startPoint, rotateAngle);
    CGPoint nearPoint = CGPointMake(startPoint.x + nearRadius * sinf(index * menuWholeAngle / count), startPoint.y - nearRadius * cosf(index * menuWholeAngle / count));
    item.nearPoint = RotateCGPointAroundCenter(nearPoint, startPoint, rotateAngle);
    CGPoint farPoint = CGPointMake(startPoint.x + farRadius * sinf(index * menuWholeAngle / count), startPoint.y - farRadius * cosf(index * menuWholeAngle / count));
    
    item.farPoint = RotateCGPointAroundCenter(farPoint, startPoint, rotateAngle);

}

@end
