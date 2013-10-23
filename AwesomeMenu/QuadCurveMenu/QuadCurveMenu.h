//
//  QuadCurveMenu.h
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuadCurveMenuItem.h"
#import "QuadCurveAnimation.h"
#import "QuadCurveMotionDirector.h"
#import "QuadCurveDataSourceDelegate.h"
#import "QuadCurveMenuItemFactory.h"
#import "QuadCurveMenuDelegate.h"

@protocol QuadCurveMenuDelegate;
@protocol QuadCurveDataSourceDelegate;
@protocol QuadCurveMenuItemFactory;

@interface QuadCurveMenu : UIView <QuadCurveMenuItemEventDelegate>

@property (readwrite, strong, nonatomic) id<QuadCurveMotionDirector> menuDirector;

@property (readwrite, strong, nonatomic) id<QuadCurveMenuItemFactory> mainMenuItemFactory;
@property (readwrite, strong, nonatomic) id<QuadCurveMenuItemFactory> menuItemFactory;

@property (readwrite, strong, nonatomic) id<QuadCurveAnimation> selectedAnimation;
@property (readwrite, strong, nonatomic) id<QuadCurveAnimation> unselectedanimation;
@property (readwrite, strong, nonatomic) id<QuadCurveAnimation> expandItemAnimation;
@property (readwrite, strong, nonatomic) id<QuadCurveAnimation> closeItemAnimation;
@property (readwrite, strong, nonatomic) id<QuadCurveAnimation> mainMenuExpandAnimation;
@property (readwrite, strong, nonatomic) id<QuadCurveAnimation> mainMenuCloseAnimation;

@property (readwrite, weak, nonatomic)   id<QuadCurveMenuDelegate> delegate;
@property (readwrite, strong, nonatomic) id<QuadCurveDataSourceDelegate> dataSource;

@property (readwrite, assign, nonatomic, getter = isExpanding) BOOL expanding;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)array;

- (id)initWithFrame:(CGRect)frame dataSource:(id<QuadCurveDataSourceDelegate>)dataSource;

- (id)initWithFrame:(CGRect)frame mainMenuImage:(NSString *)mainMenuItemImage menuItemImageArray:(NSArray *)array;

- (id)initWithFrame:(CGRect)frame
        centerPoint:(CGPoint)centerPoint
         dataSource:(id<QuadCurveDataSourceDelegate>)dataSource 
    mainMenuFactory:(id<QuadCurveMenuItemFactory>)mainFactory 
    menuItemFactory:(id<QuadCurveMenuItemFactory>)menuItemFactory;

- (id)initWithFrame:(CGRect)frame
        centerPoint:(CGPoint)centerPoint
         dataSource:(id<QuadCurveDataSourceDelegate>)dataSource 
    mainMenuFactory:(id<QuadCurveMenuItemFactory>)mainFactory 
    menuItemFactory:(id<QuadCurveMenuItemFactory>)menuItemFactory
       menuDirector:(id<QuadCurveMotionDirector>)motionDirector;

#pragma mark - Expansion / Closing

- (void)expandMenu;
- (void)expandMenuAnimated:(BOOL)animated;

- (void)closeMenu;
- (void)closeMenuAnimated:(BOOL)animated;

@end