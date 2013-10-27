//
//  QCMMenu.h
//  QuadCurveMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCMMenuItem.h"
#import "QCMAnimation.h"
#import "QCMMotionDirector.h"
#import "QCMDataSourceDelegate.h"
#import "QCMMenuItemFactory.h"
#import "QCMMenuDelegate.h"

@protocol QCMMenuDelegate;
@protocol QCMDataSourceDelegate;
@protocol QCMMenuItemFactory;

@interface QCMMenu : UIView <QCMMenuItemEventDelegate>

@property (readwrite, strong, nonatomic) id<QCMMotionDirector> menuDirector;

@property (readwrite, strong, nonatomic) id<QCMMenuItemFactory> mainMenuItemFactory;
@property (readwrite, strong, nonatomic) id<QCMMenuItemFactory> menuItemFactory;

@property (readwrite, strong, nonatomic) id<QCMAnimation> selectedAnimation;
@property (readwrite, strong, nonatomic) id<QCMAnimation> unselectedanimation;
@property (readwrite, strong, nonatomic) id<QCMAnimation> expandItemAnimation;
@property (readwrite, strong, nonatomic) id<QCMAnimation> closeItemAnimation;
@property (readwrite, strong, nonatomic) id<QCMAnimation> mainMenuExpandAnimation;
@property (readwrite, strong, nonatomic) id<QCMAnimation> mainMenuCloseAnimation;

@property (readwrite, weak, nonatomic)   id<QCMMenuDelegate> delegate;
@property (readwrite, strong, nonatomic) id<QCMDataSourceDelegate> dataSource;

@property (readonly, assign, nonatomic) CGPoint centerPoint;
@property (readonly, strong, nonatomic) QCMMenuItem *mainItem;

@property (readwrite, assign, nonatomic, getter = isExpanding) BOOL expanding;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)array;

- (id)initWithFrame:(CGRect)frame dataSource:(id<QCMDataSourceDelegate>)dataSource;

- (id)initWithFrame:(CGRect)frame mainMenuImage:(NSString *)mainMenuItemImage menuItemImageArray:(NSArray *)array;

- (id)initWithFrame:(CGRect)frame
        centerPoint:(CGPoint)centerPoint
         dataSource:(id<QCMDataSourceDelegate>)dataSource 
    mainMenuFactory:(id<QCMMenuItemFactory>)mainFactory 
    menuItemFactory:(id<QCMMenuItemFactory>)menuItemFactory;

- (id)initWithFrame:(CGRect)frame
        centerPoint:(CGPoint)centerPoint
         dataSource:(id<QCMDataSourceDelegate>)dataSource 
    mainMenuFactory:(id<QCMMenuItemFactory>)mainFactory 
    menuItemFactory:(id<QCMMenuItemFactory>)menuItemFactory
       menuDirector:(id<QCMMotionDirector>)motionDirector;

#pragma mark - Expansion / Closing

- (void)expandMenu;
- (void)expandMenuAnimated:(BOOL)animated;

- (void)closeMenu;
- (void)closeMenuAnimated:(BOOL)animated;

@end