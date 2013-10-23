//
//  AwesomeMenuItemFactory.h
//  AwesomeMenu
//
//  Created by Franklin Webber on 3/29/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuadCurveMenu.h"

@interface AwesomeMenuItemFactory : NSObject <QuadCurveMenuItemFactory>

+ (id)facebookMenuItem;
+ (id)userMenuItem;

@end
