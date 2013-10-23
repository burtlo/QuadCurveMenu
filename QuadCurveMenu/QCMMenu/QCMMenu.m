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

@property (readwrite, strong, nonatomic) QCMMenuItem *mainMenuButton;
@property (readwrite, assign, nonatomic) CGPoint centerPoint;
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

#pragma mark - Main Menu Item

- (void)setMainMenuItemFactory:(id<QCMMenuItemFactory>)mainMenuItemFactory {
    
    [self.mainMenuButton removeFromSuperview];
    
    _mainMenuItemFactory = mainMenuItemFactory;
    
    self.mainMenuButton = [[self mainMenuItemFactory] createMenuItemWithDataObject:nil];
    self.mainMenuButton.delegate = self;
    
    self.mainMenuButton.center = self.centerPoint;
    
    [self addSubview:self.mainMenuButton];
    [self setNeedsDisplay];
    
}

#pragma mark - Event Delegate

- (void)setDelegate:(id<QCMMenuDelegate>)delegate {
    
    _delegate = delegate;
    
    self.delegateHasDidTapMainMenu = [delegate respondsToSelector:@selector(QCMMenu:didTapMenu:)];
    self.delegateHasDidLongPressMainMenu = [delegate respondsToSelector:@selector(QCMMenu:didLongPressMenu:)];
    
    self.delegateHasDidTapMenuItem = [delegate respondsToSelector:@selector(QCMMenu:didTapMenuItem:)];
    self.delegateHasDidLongPressMenuItem = [delegate respondsToSelector:@selector(QCMMenu:didLongPressMenu:)];
    
    self.delegateHasShouldExpand = [delegate respondsToSelector:@selector(QCMMenuShouldExpand:)];
    self.delegateHasShouldClose = [delegate respondsToSelector:@selector(QCMMenuShouldClose:)];
    self.delegateHasWillExpand = [delegate respondsToSelector:@selector(QCMMenuWillExpand:)];
    self.delegateHasDidExpand = [delegate respondsToSelector:@selector(QCMMenuDidExpand:)];
    self.delegateHasWillClose = [delegate respondsToSelector:@selector(QCMMenuWillClose:)];
    self.delegateHasDidClose = [delegate respondsToSelector:@selector(QCMMenuDidClose:)];
}

#pragma mark - Data Source Delegate

- (NSUInteger)numberOfDisplayableItems {
    return self.dataSource.numberOfMenuItems;
}

- (id)dataObjectAtIndex:(NSUInteger)index {
    return [self.dataSource dataObjectAtIndex:index];
}

- (QCMMenuItem *)menuItemAtIndex:(NSUInteger)index {
    QCMMenuItem *item = (QCMMenuItem *)[self viewWithTag:kQCMMenuItemStartingTag + index];
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

#pragma mark - QCMMenuItemEventDelegate Adherence


#pragma mark Tap Event

- (void)QCMMenuItemTapped:(QCMMenuItem *)item {
    
    if (item == self.mainMenuButton) {
        [self mainMenuItemTapped];
    } else {
        [self menuItemTapped:item];
    }
}

- (void)mainMenuItemTapped {
    
    if (self.delegateHasDidTapMainMenu) {
        [self.delegate QCMMenu:self didTapMenu:self.mainMenuButton];
    }
    
    BOOL willBeExpandingMenu = !self.expanding;
    BOOL shouldPerformAction = YES;
    
    if (willBeExpandingMenu && self.delegateHasShouldExpand) {
        shouldPerformAction = [self.delegate QCMMenuShouldExpand:self];
    }
    
    if ( ! willBeExpandingMenu && self.delegateHasShouldClose) {
        shouldPerformAction = [self.delegate QCMMenuShouldClose:self];
    }
    
    if (shouldPerformAction) {
        [self setExpanding:willBeExpandingMenu animated:YES];
    }
    
}

- (void)menuItemTapped:(QCMMenuItem *)item {
    
    if (self.delegateHasDidTapMenuItem) {
        [self.delegate QCMMenu:self didTapMenuItem:item];
    }
    
    [self animateMenuItems:@[item] withAnimation:[self selectedAnimation]];
    
    NSPredicate *otherItems = [NSPredicate predicateWithFormat:@"tag != %d",[item tag]];
    
    NSArray *otherMenuItems = [[self allMenuItemsBeingDisplayed] filteredArrayUsingPredicate:otherItems];
    
    [self animateMenuItems:otherMenuItems withAnimation:[self unselectedanimation]];
    
    self.expanding = NO;
    
    [self performCloseMainMenuAnimated:YES];
}

#pragma mark Long Press Event

- (void)QCMMenuItemLongPressed:(QCMMenuItem *)item {
    if (item == self.mainMenuButton) {
        [self mainMenuItemLongPressed];
    } else {
        [self menuItemLongPressed:item];
    }
}

- (void)mainMenuItemLongPressed {
    if (self.delegateHasDidLongPressMainMenu) {
        [self.delegate QCMMenu:self didLongPressMenu:self.mainMenuButton];
    }
}

- (void)menuItemLongPressed:(QCMMenuItem *)item {
    if (self.delegateHasDidLongPressMenuItem) {
        [self.delegate QCMMenu:self didLongPressMenuItem:item];
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
    
    [self.mainMenuButton.layer addAnimation:[animation animationForItem:self.mainMenuButton]
                                forKey:animation.animationName];

}

- (void)performExpandMainMenuAnimated:(BOOL)animated {

    id<QCMAnimation> animation = self.noAnimation;
    if (animated) { animation = self.mainMenuExpandAnimation; }

    [self.mainMenuButton.layer addAnimation:[animation animationForItem:self.mainMenuButton]
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
    _expanding = expanding;

    if (self.expanding) {
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
    
    [self.menuDirector positionMenuItem:item atIndex:index ofCount:count fromMenu:self.mainMenuButton];
    
    [self insertSubview:item belowSubview:self.mainMenuButton];
}

- (void)addMenuItemsToViewAndPerform:(void (^)(QCMMenuItem *item))block {
    NSUInteger total = [self numberOfDisplayableItems];
    for (NSUInteger index = 0; index < total; index ++) {
        QCMMenuItem *item = [self menuItemAtIndex:index];
        [self addMenuItem:item toViewAtPosition:NSMakeRange(index,total)];
        block(item);
    }
}

#pragma mark - Animate MenuItems Expanded

- (void)notifyDelegateMenuDidExpand:(QCMMenu *)menu {
    if (self.delegateHasDidExpand) {
        [self.delegate QCMMenuDidExpand:menu];
    }
}

- (void)performExpandMenuAnimated:(BOOL)animated {
    if (self.delegateHasWillExpand) {
        [self.delegate QCMMenuWillExpand:self];
    }
    
    [self addMenuItemsToViewAndPerform:^(QCMMenuItem *item) {
        item.center = item.startPoint;
    }];
    
    NSArray *itemToBeAnimated = [self allMenuItemsBeingDisplayed];

    id<QCMAnimation> animation = self.noAnimation;
    if (animated) { animation = self.expandItemAnimation; }
    
    for (NSUInteger x = 0; x < [itemToBeAnimated count]; x++) {
        QCMMenuItem *item = itemToBeAnimated[x];
        NSDictionary *dictionary = @{@"menuItem": item,@"animation": animation};
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
        [self.delegate QCMMenuDidClose:menu];
    }
}

- (void)performCloseMenuAnimated:(BOOL)animated {
    
    if (self.delegateHasWillClose) {
        [self.delegate QCMMenuWillClose:self];
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
