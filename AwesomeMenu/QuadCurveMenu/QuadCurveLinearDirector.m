//
//  QuadCurveLinearDirector.m
//  AwesomeMenu
//
//  Created by Franklin Webber on 3/30/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "QuadCurveLinearDirector.h"

static CGFloat const kQuadCurveDefaultPadding = 10.0f;

static CGFloat const kQuadCurveMenuDefaultTimeOffset = 0.036f;
static CGFloat const kQuadCurveMenuDefaultStartPointX = 20.0;
static CGFloat const kQuadCurveMenuDefaultStartPointY = 240.0;

@interface QuadCurveLinearDirector ()

@property (nonatomic,assign) CGFloat angle;

@end

@implementation QuadCurveLinearDirector

@synthesize angle;

@synthesize timeOffset;

#pragma mark - Initialization

- (id)initWithAngle:(CGFloat)_angle {
    
    self = [super init];
    if (self) {
        
        self.timeOffset = kQuadCurveMenuDefaultTimeOffset;

        self.angle = _angle;
    }
    return self;
}


- (id)init {
    return [self initWithAngle:0];
}


#pragma mark - QuadCurveDirector Adherence


- (void)positionMenuItem:(QuadCurveMenuItem *)item 
                 atIndex:(int)index 
                 ofCount:(int)count 
                fromMenu:(QuadCurveMenuItem *)mainMenuItem {
    
    CGPoint startPoint = mainMenuItem.center;
    
    item.startPoint = startPoint;
    
    CGSize itemSize = item.frame.size;
        
    float xCoefficient = cosf(self.angle);
    float yCoefficient = sinf(self.angle);
    
    float endRadiusX = (itemSize.width + kQuadCurveDefaultPadding) * (index + 1);
    float endRadiusY = (itemSize.width + kQuadCurveDefaultPadding) * (index + 1);
    
    CGPoint endPoint = CGPointMake(startPoint.x + endRadiusX * xCoefficient, startPoint.y - endRadiusY * yCoefficient);
    
    item.endPoint = endPoint;
    
    CGPoint nearPoint = CGPointMake(startPoint.x + (endRadiusX - 10) * xCoefficient, startPoint.y - (endRadiusY - 10) * yCoefficient);
    
    item.nearPoint = nearPoint;
    
    CGPoint farPoint = CGPointMake(startPoint.x + (endRadiusX + 10) * xCoefficient, startPoint.y - (endRadiusY + 10) * yCoefficient);
    
    item.farPoint = farPoint;
    
}


@end
