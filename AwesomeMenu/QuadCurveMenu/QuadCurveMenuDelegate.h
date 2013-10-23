//
//  QuadCurveMenuDelegate.h
//  AwesomeMenu
//
//  Created by Franklin Webber on 4/2/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveMenu.h"
#import "QuadCurveMenuItem.h"

@class QuadCurveMenu;
@class QuadCurveMenuItem;

@protocol QuadCurveMenuDelegate <NSObject>

@optional

- (void)quadCurveMenu:(QuadCurveMenu *)menu didTapMenu:(QuadCurveMenuItem *)mainMenuItem;
- (void)quadCurveMenu:(QuadCurveMenu *)menu didLongPressMenu:(QuadCurveMenuItem *)mainMenuItem;

- (BOOL)quadCurveMenuShouldExpand:(QuadCurveMenu *)menu;
- (BOOL)quadCurveMenuShouldClose:(QuadCurveMenu *)menu;

- (void)quadCurveMenuWillExpand:(QuadCurveMenu *)menu;
- (void)quadCurveMenuDidExpand:(QuadCurveMenu *)menu;

- (void)quadCurveMenuWillClose:(QuadCurveMenu *)menu;
- (void)quadCurveMenuDidClose:(QuadCurveMenu *)menu;

- (void)quadCurveMenu:(QuadCurveMenu *)menu didTapMenuItem:(QuadCurveMenuItem *)menuItem;
- (void)quadCurveMenu:(QuadCurveMenu *)menu didLongPressMenuItem:(QuadCurveMenuItem *)menuItem;

@end