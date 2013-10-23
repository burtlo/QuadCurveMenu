//
//  QCMMenuDelegate.h
//  QuadCurveMenu
//
//  Created by Franklin Webber on 4/2/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMMenu.h"
#import "QCMMenuItem.h"

@class QCMMenu;
@class QCMMenuItem;

@protocol QCMMenuDelegate <NSObject>

@optional

- (void)QCMMenu:(QCMMenu *)menu didTapMenu:(QCMMenuItem *)mainMenuItem;
- (void)QCMMenu:(QCMMenu *)menu didLongPressMenu:(QCMMenuItem *)mainMenuItem;

- (BOOL)QCMMenuShouldExpand:(QCMMenu *)menu;
- (BOOL)QCMMenuShouldClose:(QCMMenu *)menu;

- (void)QCMMenuWillExpand:(QCMMenu *)menu;
- (void)QCMMenuDidExpand:(QCMMenu *)menu;

- (void)QCMMenuWillClose:(QCMMenu *)menu;
- (void)QCMMenuDidClose:(QCMMenu *)menu;

- (void)QCMMenu:(QCMMenu *)menu didTapMenuItem:(QCMMenuItem *)menuItem;
- (void)QCMMenu:(QCMMenu *)menu didLongPressMenuItem:(QCMMenuItem *)menuItem;

@end