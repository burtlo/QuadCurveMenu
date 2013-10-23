//
//  QuadCurveLinearDirector.m
//  AwesomeMenu
//
//  Created by Franklin Webber on 3/30/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveLinearDirector.h"

static CGFloat const kQuadCurveDefaultPadding = 10.0;

@implementation QuadCurveLinearDirector

#pragma mark - Initialization

- (id)initWithAngle:(CGFloat)angle 
         andPadding:(CGFloat)padding {
    self = [super init];
    if (self) {
        self.angle = angle;
        self.padding = padding;
    }
    return self;
}

+ (instancetype)directorWithAngle:(CGFloat)angle andPadding:(CGFloat)padding {
	return [[self alloc] initWithAngle:angle andPadding:padding];
}

- (id)init {
    return [self initWithAngle:0 andPadding:kQuadCurveDefaultPadding];
}

+ (instancetype)director {
	return [[self alloc] init];
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
    
    float endRadiusX = (itemSize.width + self.padding) * (index + 1);
    float endRadiusY = (itemSize.width + self.padding) * (index + 1);
    
    item.endPoint = CGPointMake(startPoint.x + endRadiusX * xCoefficient, startPoint.y - endRadiusY * yCoefficient);
    item.nearPoint = CGPointMake(startPoint.x + (endRadiusX - 10) * xCoefficient, startPoint.y - (endRadiusY - 10) * yCoefficient);
    item.farPoint = CGPointMake(startPoint.x + (endRadiusX + 10) * xCoefficient, startPoint.y - (endRadiusY + 10) * yCoefficient);
}


@end
