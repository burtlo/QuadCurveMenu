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

@property (nonatomic, strong) id<QuadCurveMotionDirector> menuDirector;

@property (nonatomic, strong) id<QuadCurveMenuItemFactory> mainMenuItemFactory;
@property (nonatomic, strong) id<QuadCurveMenuItemFactory> menuItemFactory;

@property (nonatomic, strong) id<QuadCurveAnimation> selectedAnimation;
@property (nonatomic, strong) id<QuadCurveAnimation> unselectedanimation;
@property (nonatomic, strong) id<QuadCurveAnimation> expandItemAnimation;
@property (nonatomic, strong) id<QuadCurveAnimation> closeItemAnimation;
@property (nonatomic, strong) id<QuadCurveAnimation> mainMenuExpandAnimation;
@property (nonatomic, strong) id<QuadCurveAnimation> mainMenuCloseAnimation;

@property (nonatomic, weak) id<QuadCurveMenuDelegate> delegate;
@property (nonatomic, strong) id<QuadCurveDataSourceDelegate> dataSource;

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

@property (nonatomic, getter = isExpanding) BOOL expanding;

- (void)expandMenu;
- (void)expandMenuAnimated:(BOOL)animated;

- (void)closeMenu;
- (void)closeMenuAnimated:(BOOL)animated;

@end
