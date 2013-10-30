//
//  QCMRadialDirector.m
//  QuadCurveMenu
//
//  Created by Franklin Webber on 3/30/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMRadialDirector.h"

static CGFloat const kQCMMenuDefaultRadius = 120.0;
static CGFloat const kQCMMenuDefaultNearRadiusFactor = 0.85;
static CGFloat const kQCMMenuDefaultFarRadiusFactor = 1.15;
static CGFloat const kQCMMenuDefaultTimeOffset = 0.036;
static CGFloat const kQCMMenuDefaultStartAngle = 0.0;
static CGFloat const kQCMMenuFullCircleArcAngle = M_PI * 2;

static CGPoint RotateCGPointAroundCenter(CGPoint point, CGPoint center, CGFloat angle) {
	CGAffineTransform translation = CGAffineTransformMakeTranslation(center.x, center.y);
	CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
	CGAffineTransform transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation);
	return CGPointApplyAffineTransform(point, transformGroup);	
}

static CGFloat QCMDistanceToEdgeOfEnclosingRect(CGPoint point, CGRect rect, CGRectEdge edge) {
	CGFloat distance = 0.0;
	switch (edge) {
		case CGRectMinYEdge: distance = point.y - CGRectGetMinY(rect); break; // top
		case CGRectMaxYEdge: distance = CGRectGetMaxY(rect) - point.y; break; // bottom
		case CGRectMinXEdge: distance = point.x - CGRectGetMinX(rect); break; // left
		case CGRectMaxXEdge: distance = CGRectGetMaxX(rect) - point.x; break; // right
		default: break;
	}
	return distance;
}

static CGFloat QCMAngleFromDistanceToEdgeAndRadius(CGFloat distance, CGFloat radius) {
	return asin(sqrt(pow(radius, 2) - pow(distance, 2)) / radius);
}

@implementation QCMRadialDirector

#pragma mark - Initialization

- (id)initWithArcAngle:(CGFloat)arcAngle 
		  startAngle:(CGFloat)startAngle {
	self = [super init];
	if (self) {
		self.radius = [[self class] defaultRadius];
		self.nearRadiusFactor = [[self class] defaultNearRadiusFactor];
		self.farRadiusFactor = [[self class] defaultFarRadiusFactor];
		
		self.startAngle = startAngle;
		self.arcAngle = arcAngle;
	}
	return self;
}

- (id)initWithArcAngle:(CGFloat)arcAngle {
	return [self initWithArcAngle:arcAngle 
					 startAngle:[[self class] defaultStartAngle]];
}

- (id)init {
	return [self initWithArcAngle:[[self class] defaultArcAngle]
					 startAngle:[[self class] defaultStartAngle]];
}

+ (instancetype)director {
	return [[self alloc] init];
}

+ (instancetype)directorWithArcAngle:(CGFloat)arcAngle {
	return [[self alloc] initWithArcAngle:arcAngle];
}

+ (instancetype)directorWithArcAngle:(CGFloat)arcAngle startAngle:(CGFloat)startAngle {
	return [[self alloc] initWithArcAngle:arcAngle startAngle:startAngle];
}

#pragma mark - Helper

//
// When the angle is 360 degrees, M_PI * 2, we do not want to use the entire 360 degrees
// becaues the last element will overlap with the first element. However, when we are
// less than 360 degrees we probably want to use the entire angle (e.g. 180) as there is
// no overlap.
//
// This can be overriden by subclasses
//

- (BOOL)useArcAngle {
	return self.arcAngle != kQCMMenuFullCircleArcAngle;
}

+ (CGFloat)defaultRadius {
	return kQCMMenuDefaultRadius;
}

+ (CGFloat)defaultNearRadiusFactor {
	return kQCMMenuDefaultNearRadiusFactor;
}

+ (CGFloat)defaultFarRadiusFactor {
	return kQCMMenuDefaultFarRadiusFactor;
}

+ (CGFloat)defaultArcAngle {
	return kQCMMenuFullCircleArcAngle;
}

+ (CGFloat)defaultStartAngle {
	return 0.0;
}

+ (BOOL)getRecommendedArcAngle:(CGFloat *)arcAngle startAngle:(CGFloat *)startAngle forMenuWithCenter:(CGPoint)centerPoint andRadius:(CGFloat)radius inRect:(CGRect)rect {
	NSAssert(arcAngle, @"Method argument 'arcAngle' must not be NULL");
	NSAssert(startAngle, @"Method argument 'startAngle' must not be NULL");
	
	CGFloat quarter = M_PI / 2;
	CGRectEdge edges[4] = {CGRectMinYEdge, CGRectMaxXEdge, CGRectMaxYEdge, CGRectMinXEdge};
	
	BOOL clippedByCorner = NO;
	for (NSUInteger i = 0; i < 4 && !clippedByCorner; i++) {
		CGFloat distanceA = QCMDistanceToEdgeOfEnclosingRect(centerPoint, rect, edges[i]);
		CGFloat distanceB = QCMDistanceToEdgeOfEnclosingRect(centerPoint, rect, edges[(i + 1) % 4]);
		if (distanceA <= radius && distanceB <= radius) {
			CGFloat angleA = QCMAngleFromDistanceToEdgeAndRadius(distanceA, radius);
			CGFloat angleB = QCMAngleFromDistanceToEdgeAndRadius(distanceB, radius);
			*startAngle = ((i + 1) * quarter) + angleB;
			*arcAngle = kQCMMenuFullCircleArcAngle - (angleA + quarter + angleB);
			clippedByCorner = YES;
		}
	}
	
	BOOL clippedByEdge = NO;
	if (!clippedByCorner) {
		for (NSUInteger i = 0; i < 4 && !clippedByEdge; i++) {
			CGFloat distance = QCMDistanceToEdgeOfEnclosingRect(centerPoint, rect, edges[i]);
			if (distance <= radius) {
				CGFloat angle = QCMAngleFromDistanceToEdgeAndRadius(distance, radius);
				*startAngle = (i * quarter) + angle;
				*arcAngle = kQCMMenuFullCircleArcAngle - (2 * angle);
				clippedByEdge = YES;
			}
		}
	}
	
	BOOL clipped = clippedByCorner || clippedByEdge;
	
	if (!clipped) {
		*startAngle = [self defaultStartAngle];
		*arcAngle = [self defaultArcAngle];
	}
	
	return clipped;
}

+ (BOOL)getRecommendedArcAngle:(CGFloat *)arcAngle forMenuWithRadius:(CGFloat)radius numberOfItems:(NSUInteger)itemCount ofSize:(CGSize)itemSize spacing:(CGFloat)spacing {
	NSAssert(arcAngle, @"Method argument 'arcAngle' must not be NULL");
	CGFloat size = (itemSize.width + itemSize.height) / 2;
	CGFloat requiredSpace = (itemCount * size) + (spacing * (itemCount - 1));
	*arcAngle = ((2 * M_PI * radius) / requiredSpace) * kQCMMenuFullCircleArcAngle;
	return YES;
}

+ (BOOL)getRecommendedRadius:(CGFloat *)radius forMenuWithArcAngle:(CGFloat )arcAngle numberOfItems:(NSUInteger)itemCount ofSize:(CGSize)itemSize spacing:(CGFloat)spacing {
	NSAssert(radius, @"Method argument 'radius' must not be NULL");
	CGFloat size = (itemSize.width + itemSize.height) / 2;
	CGFloat requiredSpace = (itemCount * size) + (spacing * (itemCount - 1));
	*radius = requiredSpace / (arcAngle);
	return YES;
}

#pragma mark - QCMMotionDirector Adherence

- (void)positionMenuItem:(QCMMenuItem *)item atIndex:(NSUInteger)index ofCount:(NSUInteger)count fromMenu:(QCMMenuItem *)mainMenuItem {
	
	CGPoint startPoint = mainMenuItem.center;
	item.startPoint = startPoint;
	
	CGFloat itemAngle = index * self.arcAngle / (self.useArcAngle ? count - 1 : count);
	CGFloat xCoefficient = sinf(itemAngle);
	CGFloat yCoefficient = cosf(itemAngle);
	
	CGFloat radius = self.radius;
	CGFloat nearRadius = radius * self.nearRadiusFactor;
	CGFloat farRadius = radius * self.farRadiusFactor;
	
	CGFloat startAngle = self.startAngle;
	
	CGPoint endPoint = CGPointMake(startPoint.x + radius * xCoefficient, startPoint.y - radius * yCoefficient);
	item.endPoint = RotateCGPointAroundCenter(endPoint, startPoint, startAngle);
	
	CGPoint nearPoint = CGPointMake(startPoint.x + nearRadius * xCoefficient, startPoint.y - nearRadius * yCoefficient);
	item.nearPoint = RotateCGPointAroundCenter(nearPoint, startPoint, startAngle);
	
	CGPoint farPoint = CGPointMake(startPoint.x + farRadius * xCoefficient, startPoint.y - farRadius * yCoefficient);
	item.farPoint = RotateCGPointAroundCenter(farPoint, startPoint, startAngle);

}

@end
