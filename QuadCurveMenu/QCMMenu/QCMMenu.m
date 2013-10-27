//
//  QCMMenu.m
//  QuadCurveMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//

#import "QCMMenu.h"
#import <QuartzCore/QuartzCore.h>

#import "QCMDefaultDataSource.h"
#import "QCMDefaultMenuItemFactory.h"
#import "QCMCustomImageMenuItemFactory.h"

#import "QCMRadialDirector.h"

#import "QCMBlowupAnimation.h"
#import "QCMShrinkAnimation.h"
#import "QCMItemExpandAnimation.h"
#import "QCMItemCloseAnimation.h"
#import "QCMTiltAnimation.h"
#import "QCMNoAnimation.h"

static NSUInteger const kQCMMenuItemStartingTag = 1000;

@interface QCMMenu ()

@property (readwrite, assign, nonatomic) BOOL delegateHasDidSingleTapMainMenu;
@property (readwrite, assign, nonatomic) BOOL delegateHasDidDoubleTapMainMenu;
@property (readwrite, assign, nonatomic) BOOL delegateHasDidLongPressMainMenu;
@property (readwrite, assign, nonatomic) BOOL delegateHasDidSingleTapMenuItem;
@property (readwrite, assign, nonatomic) BOOL delegateHasDidLongPressMenuItem;
@property (readwrite, assign, nonatomic) BOOL delegateHasShouldExpand;
@property (readwrite, assign, nonatomic) BOOL delegateHasWillExpand;
@property (readwrite, assign, nonatomic) BOOL delegateHasDidExpand;

@property (readwrite, assign, nonatomic) BOOL delegateHasShouldClose;
@property (readwrite, assign, nonatomic) BOOL delegateHasWillClose;
@property (readwrite, assign, nonatomic) BOOL delegateHasDidClose;

@property (readwrite, assign, nonatomic) BOOL delegateHasShouldMove;
@property (readwrite, assign, nonatomic) BOOL delegateHasWillMove;
@property (readwrite, assign, nonatomic) BOOL delegateHasDidMove;

@property (readwrite, strong, nonatomic) QCMMenuItem *mainItem;
@property (readwrite, strong, nonatomic) id<QCMAnimation> noAnimation;

@end

#pragma mark - Implementation

@implementation QCMMenu

#pragma mark - Initialization & Deallocation

- (id)initWithFrame:(CGRect)frame 
        centerPoint:(CGPoint)centerPoint
         dataSource:(id<QCMDataSourceDelegate>)dataSource 
    mainMenuFactory:(id<QCMMenuItemFactory>)mainFactory 
    menuItemFactory:(id<QCMMenuItemFactory>)menuItemFactory
       menuDirector:(id<QCMMotionDirector>)motionDirector {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.centerPoint = centerPoint;
        
        self.mainMenuItemFactory = mainFactory;
        self.menuItemFactory = menuItemFactory;
        
        self.menuDirector = motionDirector;
        
        self.selectedAnimation = [[QCMBlowupAnimation alloc] init];
        self.unselectedanimation = [[QCMShrinkAnimation alloc] init];
        
        self.expandItemAnimation = [[QCMItemExpandAnimation alloc] init];
        self.closeItemAnimation = [[QCMItemCloseAnimation alloc] init];
        
        self.mainMenuExpandAnimation = [[QCMTiltAnimation alloc] initWithCounterClockwiseTilt];
        self.mainMenuCloseAnimation = [[QCMTiltAnimation alloc] initWithTilt:0];
        
        self.noAnimation = [[QCMNoAnimation alloc] init];
        
        self.dataSource = dataSource;
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapInMenuView:)];
        [self addGestureRecognizer:singleTapGesture];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
        centerPoint:(CGPoint)centerPoint
         dataSource:(id<QCMDataSourceDelegate>)dataSource 
    mainMenuFactory:(id<QCMMenuItemFactory>)mainFactory 
    menuItemFactory:(id<QCMMenuItemFactory>)menuItemFactory {
    return [self initWithFrame:frame 
                   centerPoint:centerPoint 
                    dataSource:dataSource 
               mainMenuFactory:mainFactory 
               menuItemFactory:menuItemFactory 
                  menuDirector:[[QCMRadialDirector alloc] init]];
    
}

- (id)initWithFrame:(CGRect)frame dataSource:(id<QCMDataSourceDelegate>)dataSource {
    return [self initWithFrame:frame 
                    centerPoint:CGPointMake(frame.size.width / 2, frame.size.height / 2) 
                    dataSource:dataSource 
               mainMenuFactory:[QCMDefaultMenuItemFactory defaultMainMenuItemFactory]
               menuItemFactory:[QCMDefaultMenuItemFactory defaultMenuItemFactory]];    
}

- (id)initWithFrame:(CGRect)frame mainMenuImage:(NSString *)mainMenuItemImage menuItemImageArray:(NSArray *)array {
    return [self initWithFrame:frame
                   centerPoint:CGPointMake(frame.size.width / 2, frame.size.height / 2)
                    dataSource:[[QCMDefaultDataSource alloc] initWithArray:array]
               mainMenuFactory:[[QCMDefaultMenuItemFactory alloc] initWithImage:[UIImage imageNamed:mainMenuItemImage] highlightImage:nil]
               menuItemFactory:[[QCMCustomImageMenuItemFactory alloc] init]];
}

- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)array {
    return [self initWithFrame:frame
                    centerPoint:CGPointMake(frame.size.width / 2, frame.size.height / 2) 
                    dataSource:[[QCMDefaultDataSource alloc] initWithArray:array]
               mainMenuFactory:[QCMDefaultMenuItemFactory defaultMainMenuItemFactory]
               menuItemFactory:[QCMDefaultMenuItemFactory defaultMenuItemFactory]];
    
}

#pragma mark - Accessors

- (void)setCenterPoint:(CGPoint)centerPoint {
	_centerPoint = centerPoint;
	self.mainItem.center = centerPoint;
	[self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews {
	QCMMenuItem *mainItem = self.mainItem;
	id <QCMMotionDirector> director = self.menuDirector;
	NSUInteger total = [self numberOfDisplayableItems];
	for (NSUInteger index = 0; index < total; index ++) {
		QCMMenuItem *item = [self menuItemAtIndex:index];
		[director positionMenuItem:item atIndex:index ofCount:total fromMenu:mainItem];
		item.center = item.endPoint;
	}
}

#pragma mark - Main Menu Item

- (void)setMainMenuItemFactory:(id<QCMMenuItemFactory>)mainMenuItemFactory {
    _mainMenuItemFactory = mainMenuItemFactory;
    
	[self.mainItem removeFromSuperview];
	
    self.mainItem = [[self mainMenuItemFactory] menuMainItemForMenu:self withDataObject:nil];
    self.mainItem.delegate = self;
    self.mainItem.center = self.centerPoint;
	
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveInMenuView:)];
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [self.mainItem addGestureRecognizer:panGestureRecognizer];
    
    [self addSubview:self.mainItem];
    [self setNeedsDisplay];
}

#pragma mark - Event Delegate

- (void)setDelegate:(id<QCMMenuDelegate>)delegate {
    _delegate = delegate;
    
    self.delegateHasDidSingleTapMainMenu = [delegate respondsToSelector:@selector(quadCurveMenu:didSingleTapMainItem:)];
	self.delegateHasDidDoubleTapMainMenu = [delegate respondsToSelector:@selector(quadCurveMenu:didDoubleTapMainItem:)];
    self.delegateHasDidLongPressMainMenu = [delegate respondsToSelector:@selector(quadCurveMenu:didLongPressMainItem:)];
    self.delegateHasDidSingleTapMenuItem = [delegate respondsToSelector:@selector(quadCurveMenu:didSingleTapItem:)];
    self.delegateHasDidLongPressMenuItem = [delegate respondsToSelector:@selector(quadCurveMenu:didLongPressItem:)];
    
    self.delegateHasShouldExpand = [delegate respondsToSelector:@selector(quadCurveMenuShouldExpand:)];
    self.delegateHasWillExpand = [delegate respondsToSelector:@selector(quadCurveMenuWillExpand:)];
	self.delegateHasDidExpand = [delegate respondsToSelector:@selector(quadCurveMenuDidExpand:)];
	
	self.delegateHasShouldClose = [delegate respondsToSelector:@selector(quadCurveMenuShouldClose:)];
    self.delegateHasWillClose = [delegate respondsToSelector:@selector(quadCurveMenuWillClose:)];
    self.delegateHasDidClose = [delegate respondsToSelector:@selector(quadCurveMenuDidClose:)];
	
	self.delegateHasShouldMove = [delegate respondsToSelector:@selector(quadCurveMenuShouldMove:)];
    self.delegateHasWillMove = [delegate respondsToSelector:@selector(quadCurveMenu:willMoveFrom:to:)];
	self.delegateHasDidMove = [delegate respondsToSelector:@selector(quadCurveMenu:didMoveFrom:to:)];
}

#pragma mark - Data Source Delegate

- (NSUInteger)numberOfDisplayableItems {
    return [self.dataSource numberOfItemsInMenu:self];
}

- (id)dataObjectAtIndex:(NSUInteger)index {
    return [self.dataSource dataObjectAtIndex:index inMenu:self];
}

- (QCMMenuItem *)menuItemAtIndex:(NSUInteger)index {
    QCMMenuItem *item = (QCMMenuItem *)[self viewWithTag:kQCMMenuItemStartingTag + index];
    if (!item) {
        item = [[self menuItemFactory] menuItemForMenu:self withDataObject:[self dataObjectAtIndex:index]];
    }
	return item;
}

#pragma mark - Expand / Close Menu

- (void)expandMenu {
    [self expandMenuAnimated:YES];
}

- (void)expandMenuAnimated:(BOOL)animated {
    if (!self.expanding) {
        [self setExpanding:YES animated:animated];
    }
}

- (void)closeMenu {
    [self closeMenuAnimated:YES];
}

- (void)closeMenuAnimated:(BOOL)animated {
    if (self.expanding) {
        [self setExpanding:NO animated:animated];
    }
}

- (void)moveInMenuView:(UIPanGestureRecognizer *)panGesture {
	QCMMenuItem *mainItem = (QCMMenuItem *)panGesture.view;
	[self bringSubviewToFront:mainItem];
	[self moveMenu:[panGesture locationInView:self]];
}

- (void)moveMenu:(CGPoint)point {
	[self moveMenu:point animated:NO];
}

- (void)moveMenu:(CGPoint)point animated:(BOOL)animated {
	if (!self.delegateHasShouldMove || ![self.delegate quadCurveMenuShouldMove:self]) {
		return;
	}
	CGPoint oldPoint = self.centerPoint;
	if (self.delegateHasWillMove) {
		[self.delegate quadCurveMenu:self willMoveFrom:oldPoint to:point];
	}
	BOOL animationsEnabled = [UIView areAnimationsEnabled];
	[UIView setAnimationsEnabled:animated];
	self.centerPoint = point;
	[UIView setAnimationsEnabled:animationsEnabled];
	if (self.delegateHasDidMove) {
		[self.delegate quadCurveMenu:self didMoveFrom:oldPoint to:point];
	}
}

#pragma mark - UIView Gestures

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.expanding || CGRectContainsPoint(self.mainItem.frame, point)) {
        return YES;
    }
    return NO;
}

- (void)singleTapInMenuView:(UITapGestureRecognizer *)tapGesture {
    [self closeMenu];
}

#pragma mark - QCMMenuItemEventDelegate Adherence


#pragma mark Single Tap Event

- (void)didSingleTapQuadCurveMenuItem:(QCMMenuItem *)menuItem {
    if (menuItem == self.mainItem) {
        [self mainMenuItemSingleTapped];
    } else {
        [self menuItemSingleTapped:menuItem];
    }
}

- (void)mainMenuItemSingleTapped {
    if (self.delegateHasDidSingleTapMainMenu) {
        [self.delegate quadCurveMenu:self didSingleTapMainItem:self.mainItem];
    }
    
    BOOL willBeExpandingMenu = !self.expanding;
    BOOL shouldPerformAction = YES;
    
    if (willBeExpandingMenu && self.delegateHasShouldExpand) {
        shouldPerformAction = [self.delegate quadCurveMenuShouldExpand:self];
    }
    
    if ( ! willBeExpandingMenu && self.delegateHasShouldClose) {
        shouldPerformAction = [self.delegate quadCurveMenuShouldClose:self];
    }
    
    if (shouldPerformAction) {
        [self setExpanding:willBeExpandingMenu animated:YES];
    }
}

- (void)menuItemSingleTapped:(QCMMenuItem *)item {
    if (self.delegateHasDidSingleTapMenuItem) {
        [self.delegate quadCurveMenu:self didSingleTapItem:item];
    }
    
    [self animateMenuItems:@[item] withAnimation:[self selectedAnimation]];
    
    NSPredicate *otherItems = [NSPredicate predicateWithFormat:@"tag != %d", [item tag]];
    
    NSArray *otherMenuItems = [[self allMenuItemsBeingDisplayed] filteredArrayUsingPredicate:otherItems];
    
    [self animateMenuItems:otherMenuItems withAnimation:[self unselectedanimation]];
    
    self.expanding = NO;
    
    [self performCloseMainMenuAnimated:YES];
}

#pragma mark Double Tap Event

- (void)didDoubleTapQuadCurveMenuItem:(QCMMenuItem *)menuItem {
    if (menuItem == self.mainItem) {
        [self mainMenuItemDoubleTapped];
    } else {
        [self menuItemDoubleTapped:menuItem];
    }
}

- (void)mainMenuItemDoubleTapped {
    if (self.delegateHasDidSingleTapMainMenu) {
        [self.delegate quadCurveMenu:self didDoubleTapMainItem:self.mainItem];
    }
}

- (void)menuItemDoubleTapped:(QCMMenuItem *)item {
//    if (self.delegateHasDidDoubleTapMenuItem) {
//        [self.delegate quadCurveMenu:self didDoubleTapItem:item];
//    }
}

#pragma mark Long Press Event

- (void)didLongPressQuadCurveMenuItem:(QCMMenuItem *)menuItem {
    if (menuItem == self.mainItem) {
        [self mainMenuItemLongPressed];
    } else {
        [self menuItemLongPressed:menuItem];
    }
}

- (void)mainMenuItemLongPressed {
    if (self.delegateHasDidLongPressMainMenu) {
        [self.delegate quadCurveMenu:self didLongPressMainItem:self.mainItem];
    }
}

- (void)menuItemLongPressed:(QCMMenuItem *)item {
    if (self.delegateHasDidLongPressMenuItem) {
        [self.delegate quadCurveMenu:self didLongPressItem:item];
    }
}

#pragma mark - Selection Animations

- (void)animateMenuItems:(NSArray *)items withAnimation:(id<QCMAnimation>)animation {
    for (QCMMenuItem *item in items) {
        CAAnimationGroup *itemAnimation = [animation animationForItem:item];
        [item.layer addAnimation:itemAnimation forKey:[animation animationName]];
        item.center = item.startPoint;
    }
}

- (void)performCloseMainMenuAnimated:(BOOL)animated {
    id<QCMAnimation> animation = self.noAnimation;
    if (animated) { animation = self.mainMenuCloseAnimation; }
    
    [self.mainItem.layer addAnimation:[animation animationForItem:self.mainItem]
                                forKey:animation.animationName];
}

- (void)performExpandMainMenuAnimated:(BOOL)animated {
    id<QCMAnimation> animation = self.noAnimation;
    if (animated) { animation = self.mainMenuExpandAnimation; }

    [self.mainItem.layer addAnimation:[animation animationForItem:self.mainItem]
									 forKey:animation.animationName];
}

- (void)animateExpandMainMenuAnimated:(BOOL)animated {
    
}

- (NSArray *)allMenuItemsBeingDisplayed {
    NSPredicate *allMenuItemsPredicate = [NSPredicate predicateWithFormat:@"tag BETWEEN { %d, %d }",
                                          kQCMMenuItemStartingTag,
                                          (kQCMMenuItemStartingTag + [self numberOfDisplayableItems])];
    return [[self subviews] filteredArrayUsingPredicate:allMenuItemsPredicate];
}

#pragma mark - Expanding / Closing the Menu

- (void)setExpanding:(BOOL)expanding animated:(BOOL)animated {
    self.expanding = expanding;
    if (expanding) {
        [self performExpandMainMenuAnimated:animated];
        [self performExpandMenuAnimated:animated];
    } else {
        [self performCloseMainMenuAnimated:animated];
        [self performCloseMenuAnimated:animated];
    }
}

#pragma mark - QCMMenuItem Management

- (void)addMenuItem:(QCMMenuItem *)item toViewAtPosition:(NSRange)position {
    NSUInteger index = position.location;
    NSUInteger count = position.length;
    
    item.tag = kQCMMenuItemStartingTag + index;
    item.delegate = self;
	
    [self.menuDirector positionMenuItem:item atIndex:index ofCount:count fromMenu:self.mainItem];
    [self insertSubview:item belowSubview:self.mainItem];
}

- (void)addMenuItemsToViewAndPerform:(void (^)(QCMMenuItem *item))block {
    NSUInteger total = [self numberOfDisplayableItems];
    for (NSUInteger index = 0; index < total; index ++) {
        QCMMenuItem *item = [self menuItemAtIndex:index];
        [self addMenuItem:item toViewAtPosition:NSMakeRange(index, total)];
        block(item);
    }
}

#pragma mark - Animate MenuItems Expanded

- (void)notifyDelegateMenuDidExpand:(QCMMenu *)menu {
    if (self.delegateHasDidExpand) {
        [self.delegate quadCurveMenuDidExpand:menu];
    }
}

- (void)performExpandMenuAnimated:(BOOL)animated {
    if (self.delegateHasWillExpand) {
        [self.delegate quadCurveMenuWillExpand:self];
    }
    
    [self addMenuItemsToViewAndPerform:^(QCMMenuItem *item) {
        item.center = item.startPoint;
    }];
    
    NSArray *itemToBeAnimated = [self allMenuItemsBeingDisplayed];

    id<QCMAnimation> animation = self.noAnimation;
    if (animated) { animation = self.expandItemAnimation; }
    
    for (NSUInteger x = 0; x < [itemToBeAnimated count]; x++) {
        QCMMenuItem *item = itemToBeAnimated[x];
        NSDictionary *dictionary = @{@"menuItem": item, @"animation": animation};
        [self performSelector:@selector(animateMenuItemToEndPoint:) withObject:dictionary afterDelay:animation.delayBetweenItemAnimation * x];
    }
    
    CGFloat lastAnimationCompletesAfter = animation.delayBetweenItemAnimation * [itemToBeAnimated count] + [animation duration];
    [self performSelector:@selector(notifyDelegateMenuDidExpand:) withObject:self afterDelay:lastAnimationCompletesAfter];
}

- (void)animateMenuItemToEndPoint:(NSDictionary *)itemAndAnimation {
    id<QCMAnimation> animation = itemAndAnimation[@"animation"];
    QCMMenuItem *item = itemAndAnimation[@"menuItem"];
    
    CAAnimationGroup *expandAnimation = [animation animationForItem:item];
    [item.layer addAnimation:expandAnimation forKey:[animation animationName]];
    item.center = item.endPoint;
}

#pragma mark - Animate MenuItems Closed

- (void)notifyDelegateMenuDidClose:(QCMMenu *)menu {
    if (self.delegateHasDidClose) {
        [self.delegate quadCurveMenuDidClose:menu];
    }
}

- (void)performCloseMenuAnimated:(BOOL)animated {
    if (self.delegateHasWillClose) {
        [self.delegate quadCurveMenuWillClose:self];
    }
    
    NSArray *itemToBeAnimated = [self allMenuItemsBeingDisplayed];
    
    id<QCMAnimation> animation = self.noAnimation;
    if (animated) {
		animation = self.closeItemAnimation;
	}
    
    for (NSUInteger x = 0; x < [itemToBeAnimated count]; x++) {
        QCMMenuItem *item = itemToBeAnimated[x];
        NSDictionary *dictionary = @{@"menuItem": item,@"animation": animation};
        [self performSelector:@selector(animateItemToStartPoint:) withObject:dictionary afterDelay:animation.delayBetweenItemAnimation * x];
    }
    
    CGFloat lastAnimationCompletesAfter = animation.delayBetweenItemAnimation * [itemToBeAnimated count] + [animation duration];
    [self performSelector:@selector(notifyDelegateMenuDidClose:) withObject:self afterDelay:lastAnimationCompletesAfter];
}

- (void)animateItemToStartPoint:(NSDictionary *)itemAndAnimation {
    id<QCMAnimation> animation = itemAndAnimation[@"animation"];
    QCMMenuItem *item = itemAndAnimation[@"menuItem"];

    CAAnimationGroup *closeAnimation = [animation animationForItem:item];
    [item.layer addAnimation:closeAnimation forKey:[animation animationName]];
    item.center = item.startPoint;
}

@end
