//
//  QCMMenuItemEventDelegate.h
//  QuadCurveMenu
//
//  Created by Franklin Webber on 4/2/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMMenuItem.h"

@class QCMMenuItem;

@protocol QCMMenuItemEventDelegate <NSObject>

@optional

- (void)QCMMenuItemLongPressed:(QCMMenuItem *)item;
- (void)QCMMenuItemTapped:(QCMMenuItem *)item;

@end