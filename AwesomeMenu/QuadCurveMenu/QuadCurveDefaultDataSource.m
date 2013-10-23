//
//  QuadCurveDefaultDataSource.m
//  AwesomeMenu
//
//  Created by Franklin Webber on 3/28/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveDefaultDataSource.h"

@interface QuadCurveDefaultDataSource ()

@property (readwrite, strong, nonatomic) NSArray *array;

@end

@implementation QuadCurveDefaultDataSource

- (id)initWithArray:(NSArray *)array {
	NSAssert(array, @"Method argument 'array' must not be nil");
    self = [super init];
    if (self) {
        self.array = array;
    }
    return self;
}

+ (instancetype)dataSourceWithArray:(NSArray *)array {
	return [[self alloc] initWithArray:array];
}

- (NSUInteger)numberOfMenuItems {
    return self.array.count;
}

- (id)dataObjectAtIndex:(NSUInteger)itemIndex {
    return self.array[itemIndex];
}
@end

