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

- (void)quadCurveMenu:(QCMMenu *)menu didSingleTapMainItem:(QCMMenuItem *)mainMenuItem;
- (void)quadCurveMenu:(QCMMenu *)menu didDoubleTapMainItem:(QCMMenuItem *)mainMenuItem;
- (void)quadCurveMenu:(QCMMenu *)menu didLongPressMainItem:(QCMMenuItem *)mainMenuItem;

- (void)quadCurveMenu:(QCMMenu *)menu didSingleTapItem:(QCMMenuItem *)menuItem;
- (void)quadCurveMenu:(QCMMenu *)menu didLongPressItem:(QCMMenuItem *)menuItem;

- (BOOL)quadCurveMenuShouldExpand:(QCMMenu *)menu;
- (void)quadCurveMenuWillExpand:(QCMMenu *)menu;
- (void)quadCurveMenuDidExpand:(QCMMenu *)menu;

- (BOOL)quadCurveMenuShouldClose:(QCMMenu *)menu;
- (void)quadCurveMenuWillClose:(QCMMenu *)menu;
- (void)quadCurveMenuDidClose:(QCMMenu *)menu;

- (BOOL)quadCurveMenuShouldMove:(QCMMenu *)menu;
- (void)quadCurveMenu:(QCMMenu *)menu willMoveFrom:(CGPoint)oldPoint to:(CGPoint)newPoint;
- (void)quadCurveMenu:(QCMMenu *)menu didMoveFrom:(CGPoint)oldPoint to:(CGPoint)newPoint;

@end