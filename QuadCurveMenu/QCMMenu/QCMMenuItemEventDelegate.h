//
//  QCMMenuItemEventDelegate.h
//  QuadCurveMenu
//
//  Created by Franklin Webber on 4/2/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMMenuItem.h"

@class QCMMenu, QCMMenuItem;

@protocol QCMMenuItemEventDelegate <NSObject>

@optional

- (void)didSingleTapQuadCurveMenuItem:(QCMMenuItem *)menuItem;
- (void)didDoubleTapQuadCurveMenuItem:(QCMMenuItem *)menuItem;
- (void)didLongPressQuadCurveMenuItem:(QCMMenuItem *)menuItem;

@end