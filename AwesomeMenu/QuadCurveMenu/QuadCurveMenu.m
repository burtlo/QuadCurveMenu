//
//  QuadCurveMenu.m
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//

#import "QuadCurveMenu.h"
#import <QuartzCore/QuartzCore.h>

#import "QuadCurveDefaultDataSource.h"
#import "QuadCurveDefaultMenuItemFactory.h"
#import "QuadCurveCustomImageMenuItemFactory.h"

#import "QuadCurveRadialDirector.h"

#import "QuadCurveBlowupAnimation.h"
#import "QuadCurveShrinkAnimation.h"
#import "QuadCurveItemExpandAnimation.h"
#import "QuadCurveItemCloseAnimation.h"
#import "QuadCurveTiltAnimation.h"
#import "QuadCurveNoAnimation.h"

static int const kQuadCurveMenuItemStartingTag = 1000;

@interface QuadCurveMenu ()

@property (readwrite, assign, nonatomic) BOOL delegateHasDidTapMainMenu;
@property (readwrite, assign, nonatomic) BOOL delegateHasDidLongPressMainMenu;
@property (readwrite, assign, nonatomic) BOOL delegateHasShouldExpand;
@property (readwrite, assign, nonatomic) BOOL delegateHasShouldClose;
@property (readwrite, assign, nonatomic) BOOL delegateHasWillExpand;
@property (readwrite, assign, nonatomic) BOOL delegateHasDidExpand;
@property (readwrite, assign, nonatomic) BOOL delegateHasWillClose;
@property (readwrite, assign, nonatomic) BOOL delegateHasDidClose;
@property (readwrite, assign, nonatomic) BOOL delegateHasDidTapMenuItem;
@property (readwrite, assign, nonatomic) BOOL delegateHasDidLongPressMenuItem;

@property (readwrite, strong, nonatomic) QuadCurveMenuItem *mainMenuButton;
@property (readwrite, assign, nonatomic) CGPoint centerPoint;
@property (readwrite, strong, nonatomic) id<QuadCurveAnimation> noAnimation;

@end

#pragma mark - Implementation

@implementation QuadCurveMenu

#pragma mark - Initialization & Deallocation

- (id)initWithFrame:(CGRect)frame 
        centerPoint:(CGPoint)centerPoint
         dataSource:(id<QuadCurveDataSourceDelegate>)dataSource 
    mainMenuFactory:(id<QuadCurveMenuItemFactory>)mainFactory 
    menuItemFactory:(id<QuadCurveMenuItemFactory>)menuItemFactory
       menuDirector:(id<QuadCurveMotionDirector>)motionDirector {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.centerPoint = centerPoint;
        
        self.mainMenuItemFactory = mainFactory;
        self.menuItemFactory = menuItemFactory;
        
        self.menuDirector = motionDirector;
        
        self.selectedAnimation = [[QuadCurveBlowupAnimation alloc] init];
        self.unselectedanimation = [[QuadCurveShrinkAnimation alloc] init];
        
        self.expandItemAnimation = [[QuadCurveItemExpandAnimation alloc] init];
        self.closeItemAnimation = [[QuadCurveItemCloseAnimation alloc] init];
        
        self.mainMenuExpandAnimation = [[QuadCurveTiltAnimation alloc] initWithCounterClockwiseTilt];
        self.mainMenuCloseAnimation = [[QuadCurveTiltAnimation alloc] initWithTilt:0];
        
        self.noAnimation = [[QuadCurveNoAnimation alloc] init];
        
        self.dataSource = dataSource;
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapInMenuView:)];
        [self addGestureRecognizer:singleTapGesture];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
        centerPoint:(CGPoint)centerPoint
         dataSource:(id<QuadCurveDataSourceDelegate>)dataSource 
    mainMenuFactory:(id<QuadCurveMenuItemFactory>)mainFactory 
    menuItemFactory:(id<QuadCurveMenuItemFactory>)menuItemFactory {
    
    
    return [self initWithFrame:frame 
                   centerPoint:centerPoint 
                    dataSource:dataSource 
               mainMenuFactory:mainFactory 
               menuItemFactory:menuItemFactory 
                  menuDirector:[[QuadCurveRadialDirector alloc] init]];
    
}

- (id)initWithFrame:(CGRect)frame dataSource:(id<QuadCurveDataSourceDelegate>)dataSource {
    
    return [self initWithFrame:frame 
                    centerPoint:CGPointMake(frame.size.width / 2, frame.size.height / 2) 
                    dataSource:dataSource 
               mainMenuFactory:[QuadCurveDefaultMenuItemFactory defaultMainMenuItemFactory]
               menuItemFactory:[QuadCurveDefaultMenuItemFactory defaultMenuItemFactory]];    
}

- (id)initWithFrame:(CGRect)frame mainMenuImage:(NSString *)mainMenuItemImage menuItemImageArray:(NSArray *)array {
    
    return [self initWithFrame:frame
                   centerPoint:CGPointMake(frame.size.width / 2, frame.size.height / 2)
                    dataSource:[[QuadCurveDefaultDataSource alloc] initWithArray:array]
               mainMenuFactory:[[QuadCurveDefaultMenuItemFactory alloc] initWithImage:[UIImage imageNamed:mainMenuItemImage] highlightImage:nil]
               menuItemFactory:[[QuadCurveCustomImageMenuItemFactory alloc] init]];
}

- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)array {
    
    return [self initWithFrame:frame
                    centerPoint:CGPointMake(frame.size.width / 2, frame.size.height / 2) 
                    dataSource:[[QuadCurveDefaultDataSource alloc] initWithArray:array]
               mainMenuFactory:[QuadCurveDefaultMenuItemFactory defaultMainMenuItemFactory]
               menuItemFactory:[QuadCurveDefaultMenuItemFactory defaultMenuItemFactory]];
    
}

#pragma mark - Main Menu Item

- (void)setMainMenuItemFactory:(id<QuadCurveMenuItemFactory>)mainMenuItemFactory {
    
    [self.mainMenuButton removeFromSuperview];
    
    _mainMenuItemFactory = mainMenuItemFactory;
    
    self.mainMenuButton = [[self mainMenuItemFactory] createMenuItemWithDataObject:nil];
    self.mainMenuButton.delegate = self;
    
    self.mainMenuButton.center = self.centerPoint;
    
    [self addSubview:self.mainMenuButton];
    [self setNeedsDisplay];
    
}

#pragma mark - Event Delegate

- (void)setDelegate:(id<QuadCurveMenuDelegate>)delegate {
    
    _delegate = delegate;
    
    self.delegateHasDidTapMainMenu = [delegate respondsToSelector:@selector(quadCurveMenu:didTapMenu:)];
    self.delegateHasDidLongPressMainMenu = [delegate respondsToSelector:@selector(quadCurveMenu:didLongPressMenu:)];
    
    self.delegateHasDidTapMenuItem = [delegate respondsToSelector:@selector(quadCurveMenu:didTapMenuItem:)];
    self.delegateHasDidLongPressMenuItem = [delegate respondsToSelector:@selector(quadCurveMenu:didLongPressMenu:)];
    
    self.delegateHasShouldExpand = [delegate respondsToSelector:@selector(quadCurveMenuShouldExpand:)];
    self.delegateHasShouldClose = [delegate respondsToSelector:@selector(quadCurveMenuShouldClose:)];
    self.delegateHasWillExpand = [delegate respondsToSelector:@selector(quadCurveMenuWillExpand:)];
    self.delegateHasDidExpand = [delegate respondsToSelector:@selector(quadCurveMenuDidExpand:)];
    self.delegateHasWillClose = [delegate respondsToSelector:@selector(quadCurveMenuWillClose:)];
    self.delegateHasDidClose = [delegate respondsToSelector:@selector(quadCurveMenuDidClose:)];
}

#pragma mark - Data Source Delegate

- (int)numberOfDisplayableItems {
    return self.dataSource.numberOfMenuItems;
}

- (id)dataObjectAtIndex:(int)index {
    return [self.dataSource dataObjectAtIndex:index];
}

- (QuadCurveMenuItem *)menuItemAtIndex:(int)index {
    QuadCurveMenuItem *item = (QuadCurveMenuItem *)[self viewWithTag:kQuadCurveMenuItemStartingTag + index];
    if (!item) {
        item = [[self menuItemFactory] createMenuItemWithDataObject:[self dataObjectAtIndex:index]];
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

#pragma mark - UIView Gestures

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.expanding || CGRectContainsPoint(self.mainMenuButton.frame, point)) {
        return YES;
    }
    return NO;
}

- (void)singleTapInMenuView:(UITapGestureRecognizer *)tapGesture {
    [self closeMenu];
}

#pragma mark - QuadCurveMenuItemEventDelegate Adherence


#pragma mark Tap Event

- (void)quadCurveMenuItemTapped:(QuadCurveMenuItem *)item {
    
    if (item == self.mainMenuButton) {
        [self mainMenuItemTapped];
    } else {
        [self menuItemTapped:item];
    }
}

- (void)mainMenuItemTapped {
    
    if (self.delegateHasDidTapMainMenu) {
        [self.delegate quadCurveMenu:self didTapMenu:self.mainMenuButton];
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

- (void)menuItemTapped:(QuadCurveMenuItem *)item {
    
    if (self.delegateHasDidTapMenuItem) {
        [self.delegate quadCurveMenu:self didTapMenuItem:item];
    }
    
    [self animateMenuItems:[NSArray arrayWithObject:item] withAnimation:[self selectedAnimation]];
    
    NSPredicate *otherItems = [NSPredicate predicateWithFormat:@"tag != %d",[item tag]];
    
    NSArray *otherMenuItems = [[self allMenuItemsBeingDisplayed] filteredArrayUsingPredicate:otherItems];
    
    [self animateMenuItems:otherMenuItems withAnimation:[self unselectedanimation]];
    
    self.expanding = NO;
    
    [self performCloseMainMenuAnimated:YES];
}

#pragma mark Long Press Event

- (void)quadCurveMenuItemLongPressed:(QuadCurveMenuItem *)item {
    if (item == self.mainMenuButton) {
        [self mainMenuItemLongPressed];
    } else {
        [self menuItemLongPressed:item];
    }
}

- (void)mainMenuItemLongPressed {
    if (self.delegateHasDidLongPressMainMenu) {
        [self.delegate quadCurveMenu:self didLongPressMenu:self.mainMenuButton];
    }
}

- (void)menuItemLongPressed:(QuadCurveMenuItem *)item {
    if (self.delegateHasDidLongPressMenuItem) {
        [self.delegate quadCurveMenu:self didLongPressMenuItem:item];
    }
}

#pragma mark - Selection Animations

- (void)animateMenuItems:(NSArray *)items withAnimation:(id<QuadCurveAnimation>)animation {
    for (QuadCurveMenuItem *item in items) {
        CAAnimationGroup *itemAnimation = [animation animationForItem:item];
        [item.layer addAnimation:itemAnimation forKey:[animation animationName]];
        item.center = item.startPoint;
    }
}


- (void)performCloseMainMenuAnimated:(BOOL)animated {

    id<QuadCurveAnimation> animation = self.noAnimation;
    if (animated) { animation = self.mainMenuCloseAnimation; }
    
    [self.mainMenuButton.layer addAnimation:[animation animationForItem:self.mainMenuButton]
                                forKey:animation.animationName];

}

- (void)performExpandMainMenuAnimated:(BOOL)animated {

    id<QuadCurveAnimation> animation = self.noAnimation;
    if (animated) { animation = self.mainMenuExpandAnimation; }

    [self.mainMenuButton.layer addAnimation:[animation animationForItem:self.mainMenuButton]
									 forKey:animation.animationName];
    
}

- (void)animateExpandMainMenuAnimated:(BOOL)animated {
    
}

- (NSArray *)allMenuItemsBeingDisplayed {
    
    NSPredicate *allMenuItemsPredicate = [NSPredicate predicateWithFormat:@"tag BETWEEN { %d, %d }",
                                          kQuadCurveMenuItemStartingTag,
                                          (kQuadCurveMenuItemStartingTag + [self numberOfDisplayableItems])];
    
    return [[self subviews] filteredArrayUsingPredicate:allMenuItemsPredicate];
}

#pragma mark - Expanding / Closing the Menu

- (void)setExpanding:(BOOL)expanding animated:(BOOL)animated {
    _expanding = expanding;

    if (self.expanding) {
        [self performExpandMainMenuAnimated:animated];
        [self performExpandMenuAnimated:animated];
    
    } else {
        [self performCloseMainMenuAnimated:animated];
        [self performCloseMenuAnimated:animated];
    }
}

#pragma mark - QuadCurveMenuItem Management

- (void)addMenuItem:(QuadCurveMenuItem *)item toViewAtPosition:(NSRange)position {
    
    int index = position.location;
    int count = position.length;
    
    item.tag = kQuadCurveMenuItemStartingTag + index;
    item.delegate = self;
    
    [self.menuDirector positionMenuItem:item atIndex:index ofCount:count fromMenu:self.mainMenuButton];
    
    [self insertSubview:item belowSubview:self.mainMenuButton];
}

- (void)addMenuItemsToViewAndPerform:(void (^)(QuadCurveMenuItem *item))block {
    int total = [self numberOfDisplayableItems];
    for (int index = 0; index < total; index ++) {
        QuadCurveMenuItem *item = [self menuItemAtIndex:index];
        [self addMenuItem:item toViewAtPosition:NSMakeRange(index,total)];
        block(item);
    }
}

#pragma mark - Animate MenuItems Expanded

- (void)notifyDelegateMenuDidExpand:(QuadCurveMenu *)menu {
    if (self.delegateHasDidExpand) {
        [self.delegate quadCurveMenuDidExpand:menu];
    }
}

- (void)performExpandMenuAnimated:(BOOL)animated {
    if (self.delegateHasWillExpand) {
        [self.delegate quadCurveMenuWillExpand:self];
    }
    
    [self addMenuItemsToViewAndPerform:^(QuadCurveMenuItem *item) {
        item.center = item.startPoint;
    }];
    
    NSArray *itemToBeAnimated = [self allMenuItemsBeingDisplayed];

    id<QuadCurveAnimation> animation = self.noAnimation;
    if (animated) { animation = self.expandItemAnimation; }
    
    for (NSUInteger x = 0; x < [itemToBeAnimated count]; x++) {
        QuadCurveMenuItem *item = [itemToBeAnimated objectAtIndex:x];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:item,@"menuItem",animation,@"animation", nil];
        [self performSelector:@selector(animateMenuItemToEndPoint:) withObject:dictionary afterDelay:animation.delayBetweenItemAnimation * x];
    }
    
    CGFloat lastAnimationCompletesAfter = animation.delayBetweenItemAnimation * [itemToBeAnimated count] + [animation duration];
    [self performSelector:@selector(notifyDelegateMenuDidExpand:) withObject:self afterDelay:lastAnimationCompletesAfter];
}

- (void)animateMenuItemToEndPoint:(NSDictionary *)itemAndAnimation {
    id<QuadCurveAnimation> animation = [itemAndAnimation objectForKey:@"animation"];
    QuadCurveMenuItem *item = [itemAndAnimation objectForKey:@"menuItem"];
    
    CAAnimationGroup *expandAnimation = [animation animationForItem:item];
    [item.layer addAnimation:expandAnimation forKey:[animation animationName]];
    item.center = item.endPoint;
}


#pragma mark - Animate MenuItems Closed

- (void)notifyDelegateMenuDidClose:(QuadCurveMenu *)menu {
    if (self.delegateHasDidClose) {
        [self.delegate quadCurveMenuDidClose:menu];
    }
}

- (void)performCloseMenuAnimated:(BOOL)animated {
    
    if (self.delegateHasWillClose) {
        [self.delegate quadCurveMenuWillClose:self];
    }
    
    NSArray *itemToBeAnimated = [self allMenuItemsBeingDisplayed];
    
    id<QuadCurveAnimation> animation = self.noAnimation;
    if (animated) {
		animation = self.closeItemAnimation;
	}
    
    for (int x = 0; x < [itemToBeAnimated count]; x++) {
        QuadCurveMenuItem *item = [itemToBeAnimated objectAtIndex:x];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:item,@"menuItem",animation,@"animation", nil];
        [self performSelector:@selector(animateItemToStartPoint:) withObject:dictionary afterDelay:animation.delayBetweenItemAnimation * x];
    }
    
    CGFloat lastAnimationCompletesAfter = animation.delayBetweenItemAnimation * [itemToBeAnimated count] + [animation duration];
    [self performSelector:@selector(notifyDelegateMenuDidClose:) withObject:self afterDelay:lastAnimationCompletesAfter];
}

- (void)animateItemToStartPoint:(NSDictionary *)itemAndAnimation {
    id<QuadCurveAnimation> animation = [itemAndAnimation objectForKey:@"animation"];
    QuadCurveMenuItem *item = [itemAndAnimation objectForKey:@"menuItem"];

    CAAnimationGroup *closeAnimation = [animation animationForItem:item];
    [item.layer addAnimation:closeAnimation forKey:[animation animationName]];
    item.center = item.startPoint;
}


@end
