//
//  QCMMotionDirector.h
//  QuadCurveMenu
//
//  Created by Franklin Webber on 3/30/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMMenuItem.h"

@protocol QCMMotionDirector <NSObject>

- (void)positionMenuItem:(QCMMenuItem *)item 
				 atIndex:(NSUInteger)index
				 ofCount:(NSUInteger)count 
				fromMenu:(QCMMenuItem *)mainMenuItem;

@end
