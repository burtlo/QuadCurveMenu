//
//  QCMMenuItemFactory.h
//  QuadCurveMenu
//
//  Created by Franklin Webber on 4/2/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMMenuItem.h"

@class QCMMenu;

@protocol QCMMenuItemFactory <NSObject>

- (QCMMenuItem *)menuMainItemForMenu:(QCMMenu *)menu withDataObject:(id)dataObject;
- (QCMMenuItem *)menuItemForMenu:(QCMMenu *)menu withDataObject:(id)dataObject;

@end