//
//  MenuDataSource.m
//  QuadCurveMenu
//
//  Created by Franklin Webber on 3/28/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "MenuDataSource.h"

@interface MenuDataSource () {
    NSMutableArray *dataItems;
}

@end


@implementation MenuDataSource

- (id)init {
    self = [super init];
    if (self) {
        dataItems = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
    }
    return self;
}

#pragma mark - QCMDataSourceDelegate Adherence

- (NSUInteger)numberOfMenuItems {
    return [dataItems count];
}

- (id)dataObjectAtIndex:(NSUInteger)itemIndex {
    return dataItems[itemIndex];
}

@end
