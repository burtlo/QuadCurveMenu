//
//  QuadCurveDefaultDataSource.h
//  AwesomeMenu
//
//  Created by Franklin Webber on 3/28/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuadCurveMenu.h"

@interface QuadCurveDefaultDataSource : NSObject <QuadCurveDataSourceDelegate>

- (id)initWithArray:(NSArray *)array;

@end
