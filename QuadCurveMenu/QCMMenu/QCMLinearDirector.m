//
//  QCMLinearDirector.m
//  QuadCurveMenu
//
//  Created by Franklin Webber on 3/30/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMLinearDirector.h"

static CGFloat const kQCMDefaultPadding = 10.0;

@implementation QCMLinearDirector

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
    return [self initWithAngle:0 andPadding:kQCMDefaultPadding];
}

+ (instancetype)director {
	return [[self alloc] init];
}

#pragma mark - QCMDirector Adherence

- (void)positionMenuItem:(QCMMenuItem *)item 
                 atIndex:(NSUInteger)index
                 ofCount:(NSUInteger)count
                fromMenu:(QCMMenuItem *)mainMenuItem {
    
    CGPoint startPoint = mainMenuItem.center;
    item.startPoint = startPoint;
    
    CGSize itemSize = item.frame.size;
        
    CGFloat xCoefficient = cosf(self.angle);
    CGFloat yCoefficient = sinf(self.angle);
    
    CGFloat endRadiusX = (itemSize.width + self.padding) * (index + 1);
    CGFloat endRadiusY = (itemSize.width + self.padding) * (index + 1);
    
    item.endPoint = CGPointMake(startPoint.x + endRadiusX * xCoefficient, startPoint.y - endRadiusY * yCoefficient);
    item.nearPoint = CGPointMake(startPoint.x + (endRadiusX - 10) * xCoefficient, startPoint.y - (endRadiusY - 10) * yCoefficient);
    item.farPoint = CGPointMake(startPoint.x + (endRadiusX + 10) * xCoefficient, startPoint.y - (endRadiusY + 10) * yCoefficient);
}


@end
