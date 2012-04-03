//
//  QuadCurveDataSourceDelegate.h
//  AwesomeMenu
//
//  Created by Franklin Webber on 4/2/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

@protocol QuadCurveDataSourceDelegate <NSObject>

- (int)numberOfMenuItems;
- (id)dataObjectAtIndex:(NSInteger)itemIndex;

@end
