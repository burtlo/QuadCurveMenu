//
//  QuadCurveDataSourceDelegate.h
//  QuadCurve
//
//  Created by Franklin Webber on 3/31/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QuadCurveDataSourceDelegate <NSObject>

- (int)numberOfMenuItems;
- (id)dataObjectAtIndex:(NSInteger)itemIndex;

@end
