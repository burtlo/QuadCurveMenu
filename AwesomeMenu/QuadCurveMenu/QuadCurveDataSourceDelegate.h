//
//  QuadCurveDataSourceDelegate.h
//  AwesomeMenu
//
//  Created by Franklin Webber on 4/2/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

@protocol QuadCurveDataSourceDelegate <NSObject>

- (NSUInteger)numberOfMenuItems;
- (id)dataObjectAtIndex:(NSUInteger)itemIndex;

@end
