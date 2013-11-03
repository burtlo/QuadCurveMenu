//
//  MenuDataSource.m
//  QuadCurveMenu
//
//  Created by Franklin Webber on 3/28/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "MenuDataSource.h"

@interface MenuDataSource ()

@property (readwrite, strong, nonatomic) NSArray *dataItems;

@end

@implementation MenuDataSource

- (id)init {
    self = [super init];
    if (self) {
        self.dataItems = @[@"1", @"2", @"3", @"4", @"5", @"6"];
    }
    return self;
}

#pragma mark - QCMDataSourceDelegate Adherence

- (NSUInteger)numberOfItemsInMenu:(QCMMenu *)menu {
    return self.dataItems.count;
}

- (id)dataObjectAtIndex:(NSUInteger)itemIndex inMenu:(QCMMenu *)menu {
    return self.dataItems[itemIndex];
}

@end
