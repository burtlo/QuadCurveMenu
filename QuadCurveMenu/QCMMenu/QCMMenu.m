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
	   menuDirector:(id<QCMMotionDirector>)motionDirector
	 menuDataObject:(id)menuDataObject {
	
	self = [super initWithFrame:frame];
	
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		
		self.state = QCMMenuStateClosed;
		
		self.centerPoint = centerPoint;
		
		self.menuDataObject = menuDataObject;
		self.dataSource = dataSource;
		
		self.mainMenuItemFactory = mainFactory;
		self.menuItemFactory = menuItemFactory;
		
		self.menuDirector = motionDirector;
		
		self.selectedAnimation = [[QCMBlowupAnimation alloc] init];
		self.unselectedAnimation = [[QCMShrinkAnimation alloc] init];
		
		self.expandItemAnimation = [[QCMItemExpandAnimation alloc] init];
		self.closeItemAnimation = [[QCMItemCloseAnimation alloc] init];
		
		self.mainMenuExpandAnimation = [[QCMTiltAnimation alloc] initWithCounterClockwiseTilt];
		self.mainMenuCloseAnimation = [[QCMTiltAnimation alloc] initWithTilt:0];
		
		self.noAnimation = [[QCMNoAnimation alloc] init];
		
		UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapInMenuView:)];
		[self addGestureRecognizer:singleTapGesture];
		
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
		centerPoint:(CGPoint)centerPoint
		 dataSource:(id<QCMDataSourceDelegate>)dataSource
	mainMenuFactory:(id<QCMMenuItemFactory>)mainFactory
	menuItemFactory:(id<QCMMenuItemFactory>)menuItemFactory
	   menuDirector:(id<QCMMotionDirector>)motionDirector {
	return [self initWithFrame:frame
				   centerPoint:centerPoint
					dataSource:dataSource
			   mainMenuFactory:mainFactory
			   menuItemFactory:menuItemFactory
				  menuDirector:[[QCMRadialDirector alloc] init]
				menuDataObject:nil];
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
	if (self.state == QCMMenuStateExpanded) {
		QCMMenuItem *mainItem = self.mainItem;
		id <QCMMotionDirector> director = self.menuDirector;
		NSUInteger total = [self numberOfDisplayableItems];
		for (NSUInteger index = 0; index < total; index ++) {
			QCMMenuItem *item = [self menuItemAtIndex:index];
			[director positionMenuItem:item atIndex:index ofCount:total fromMenu:mainItem];
			item.center = item.endPoint;
		}
	}
}

#pragma mark - Main Menu Item

- (void)setMainMenuItemFactory:(id<QCMMenuItemFactory>)mainMenuItemFactory {
	_mainMenuItemFactory = mainMenuItemFactory;
	
	[self.mainItem removeFromSuperview];
	
	id dataObject = self.menuDataObject;
	
	self.mainItem = [[self mainMenuItemFactory] menuMainItemForMenu:self withDataObject:dataObject];
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

- (BOOL)isClosed {
	return self.state == QCMMenuStateClosed;
}

- (BOOL)isClosingOrClosed {
	return ![self isExpandingOrExpanded];
}

- (BOOL)isExpandingOrExpanded {
	return (self.state & (QCMMenuStateExpanding | QCMMenuStateExpanded)) != 0x0;
}

- (void)expandMenu {
	[self expandMenuAnimated:YES];
}

- (void)expandMenuAnimated:(BOOL)animated {
	if ([self isExpandingOrExpanded]) {
		return;
	}
	[self performExpandAnimated:animated];
}

- (void)closeMenu {
	[self closeMenuAnimated:YES];
}

- (void)closeMenuAnimated:(BOOL)animated {
	if ([self isClosingOrClosed]) {
		return;
	}
	[self performCloseWithPressedItem:nil animated:animated];
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
	if (self.state != QCMMenuStateClosed || CGRectContainsPoint(self.mainItem.frame, point)) {
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
	
	BOOL shouldPerformAction = YES;
	BOOL isExpandingOrExpanded = [self isExpandingOrExpanded];
	BOOL isClosingOrClosed = [self isClosingOrClosed];
	
	if (!isExpandingOrExpanded && self.delegateHasShouldExpand) {
		shouldPerformAction = [self.delegate quadCurveMenuShouldExpand:self];
	}
	
	if (!isClosingOrClosed && self.delegateHasShouldClose) {
		shouldPerformAction = [self.delegate quadCurveMenuShouldClose:self];
	}
	
	if (shouldPerformAction) {
		if (isExpandingOrExpanded) {
			[self closeMenuAnimated:YES];
		} else if (isClosingOrClosed) {
			[self expandMenuAnimated:YES];
		}
	}
}

- (void)menuItemSingleTapped:(QCMMenuItem *)item {
	if (self.delegateHasDidSingleTapMenuItem) {
		[self.delegate quadCurveMenu:self didSingleTapItem:item];
	}
	[self performCloseWithPressedItem:item animated:YES];
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
//	if (self.delegateHasDidDoubleTapMenuItem) {
//		[self.delegate quadCurveMenu:self didDoubleTapItem:item];
//	}
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

- (NSArray *)allMenuItemsBeingDisplayed {
	NSPredicate *allMenuItemsPredicate = [NSPredicate predicateWithFormat:@"tag BETWEEN { %d, %d }",
										  kQCMMenuItemStartingTag,
										  (kQCMMenuItemStartingTag + [self numberOfDisplayableItems])];
	return [[self subviews] filteredArrayUsingPredicate:allMenuItemsPredicate];
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

- (void)performExpandAnimated:(BOOL)animated {
	if (self.delegateHasWillExpand) {
		[self.delegate quadCurveMenuWillExpand:self];
	}
	
	id<QCMAnimation> animation = self.noAnimation;
	if (animated) {
		animation = self.mainMenuExpandAnimation ?: self.noAnimation;
	}
	NSTimeInterval animationDuration = animation.duration;
	self.state = QCMMenuStateExpanding;
	[self.mainItem.layer addAnimation:[animation animationForItem:self.mainItem]
							   forKey:animation.animationName];
	
	[self addMenuItemsToViewAndPerform:^(QCMMenuItem *item) {
		item.center = item.startPoint;
	}];
	
	NSArray *itemsToBeAnimated = [self allMenuItemsBeingDisplayed];
	animation = self.noAnimation;
	if (animated) {
		animation = self.expandItemAnimation ?: self.noAnimation;
	}
	
	for (NSUInteger x = 0; x < [itemsToBeAnimated count]; x++) {
		QCMMenuItem *item = itemsToBeAnimated[x];
		NSTimeInterval delayInSeconds = animation.delayBetweenItemAnimation * x;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[self animateMenuItem:item toEndPointWithAnimation:animation];
		});
	}
	
	NSTimeInterval lastAnimationCompletesAfter = animation.delayBetweenItemAnimation * [itemsToBeAnimated count] + [animation duration];
	animationDuration = MAX(animationDuration, lastAnimationCompletesAfter);
	
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		self.state = QCMMenuStateExpanded;
		if (self.delegateHasDidExpand) {
			[self.delegate quadCurveMenuDidExpand:self];
		}
	});
}

- (void)animateMenuItem:(QCMMenuItem *)item toEndPointWithAnimation:(id<QCMAnimation>)animation {
	CAAnimationGroup *expandAnimation = [animation animationForItem:item];
	if (expandAnimation) {
		[item.layer addAnimation:expandAnimation forKey:[animation animationName]];
	}
	item.center = item.endPoint;
}

#pragma mark - Animate MenuItems Closed

- (void)performCloseWithPressedItem:(QCMMenuItem *)item animated:(BOOL)animated {
	if (self.delegateHasWillClose) {
		[self.delegate quadCurveMenuWillClose:self];
	}
	
	// Animate main item:
	id<QCMAnimation> animation = self.noAnimation;
	if (animated) {
		animation = self.mainMenuCloseAnimation ?: self.noAnimation;
	}
	NSTimeInterval animationDuration = animation.duration;
	self.state = QCMMenuStateClosing;
	[self.mainItem.layer addAnimation:[animation animationForItem:self.mainItem]
							   forKey:animation.animationName];
	
	// Animate menu items:
	if (item == self.mainItem || !item) {
		NSArray *itemsToBeAnimated = [self allMenuItemsBeingDisplayed];
		id<QCMAnimation> animation = self.noAnimation;
		if (animated) {
			animation = self.closeItemAnimation ?: self.noAnimation;
		}
		for (NSUInteger x = 0; x < [itemsToBeAnimated count]; x++) {
			QCMMenuItem *item = itemsToBeAnimated[x];
			NSTimeInterval delayInSeconds = animation.delayBetweenItemAnimation * x;
			dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
			dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
				[self animateMenuItem:item toStartPointWithAnimation:animation];
			});
		}
		NSTimeInterval lastAnimationCompletesAfter = animation.delayBetweenItemAnimation * [itemsToBeAnimated count] + [animation duration];
		animationDuration = MAX(animationDuration, lastAnimationCompletesAfter);
	} else {
		id<QCMAnimation> selectedAnimation = [self selectedAnimation];
		[self animateMenuItems:@[item] withAnimation:selectedAnimation];
		
		NSPredicate *otherItems = [NSPredicate predicateWithFormat:@"tag != %d", [item tag]];
		NSArray *otherMenuItems = [[self allMenuItemsBeingDisplayed] filteredArrayUsingPredicate:otherItems];
		id<QCMAnimation> unselectedAnimation = [self unselectedAnimation];
		[self animateMenuItems:otherMenuItems withAnimation:unselectedAnimation];
		animationDuration = MAX(animationDuration, MAX(selectedAnimation.duration, unselectedAnimation.duration));
	}
	
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		self.state = QCMMenuStateClosed;
		if (self.delegateHasDidClose) {
			[self.delegate quadCurveMenuDidClose:self];
		}
	});
}

- (void)animateMenuItem:(QCMMenuItem *)item toStartPointWithAnimation:(id<QCMAnimation>)animation {
	CAAnimationGroup *closeAnimation = [animation animationForItem:item];
	if (closeAnimation) {
		[item.layer addAnimation:closeAnimation forKey:[animation animationName]];
	}
	item.center = item.startPoint;
}

@end
