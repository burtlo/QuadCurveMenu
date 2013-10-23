//
//  QuadCurveMotionDirector.h
//  AwesomeMenu
//
//  Created by Franklin Webber on 3/30/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveMenuItem.h"

@protocol QuadCurveMotionDirector <NSObject>

- (void)positionMenuItem:(QuadCurveMenuItem *)item 
                 atIndex:(NSUInteger)index
                 ofCount:(NSUInteger)count 
                fromMenu:(QuadCurveMenuItem *)mainMenuItem;

@end
