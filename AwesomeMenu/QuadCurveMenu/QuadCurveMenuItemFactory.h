//
//  QuadCurveMenuItemFactory.h
//  AwesomeMenu
//
//  Created by Franklin Webber on 4/2/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveMenuItem.h"

@protocol QuadCurveMenuItemFactory <NSObject>

- (QuadCurveMenuItem *)createMenuItemWithDataObject:(id)dataObject;

@end
