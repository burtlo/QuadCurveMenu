//
//  QuadCurveMenuItem.m
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//

#import "QuadCurveMenuItem.h"

static inline CGRect ScaleRect(CGRect rect, float n) {return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);}

@interface QuadCurveMenuItem () {
    
    BOOL delegateHasLongPressed;
    BOOL delegateHasTapped;
    
}

@property (nonatomic, readonly) UIView *contentView;

- (void)longPressOnMenuItem:(UIGestureRecognizer *)sender;
- (void)singleTapOnMenuItem:(UIGestureRecognizer *)sender;

@end

@implementation QuadCurveMenuItem

@synthesize dataObject;

@synthesize contentView = contentView_;

@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize nearPoint = _nearPoint;
@synthesize farPoint = _farPoint;
@synthesize delegate  = delegate_;

#pragma mark - Initialization

- (id)initWithView:(UIView *)view {
    
    if (self = [super init]) {
        
        self.userInteractionEnabled = YES;
        
        contentView_ = view;
        [self addSubview:contentView_];
        self.frame = CGRectMake(self.center.x - contentView_.bounds.size.width/2,self.center.y - contentView_.bounds.size.height/2,contentView_.bounds.size.width, contentView_.bounds.size.height);
        
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnMenuItem:)];
        
        [self addGestureRecognizer:longPressGesture];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapOnMenuItem:)];
        
        [self addGestureRecognizer:singleTapGesture];
        
        [self setUserInteractionEnabled:YES];

        
    }
    return self;
}

#pragma mark - Delegate

- (void)setDelegate:(id<QuadCurveMenuItemEventDelegate>)delegate {
    
    delegate_ = delegate;
    
    delegateHasLongPressed = [delegate respondsToSelector:@selector(quadCurveMenuItemLongPressed:)];
    delegateHasTapped = [delegate respondsToSelector:@selector(quadCurveMenuItemTapped:)];
    
}

#pragma mark - Gestures

- (void)longPressOnMenuItem:(UILongPressGestureRecognizer *)sender {
    
    if (delegateHasLongPressed) {
        [delegate_ quadCurveMenuItemLongPressed:self];
    }
    
}

- (void)singleTapOnMenuItem:(UITapGestureRecognizer *)sender {
    
    if (delegateHasTapped) {
        [delegate_ quadCurveMenuItemTapped:self];
    }
    
}

#pragma mark - UIView's methods

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = CGRectMake(self.center.x - contentView_.bounds.size.width/2,self.center.y - contentView_.bounds.size.height/2,contentView_.bounds.size.width, contentView_.bounds.size.height);
    
    float width = contentView_.bounds.size.width;
    float height = contentView_.bounds.size.height;
    
    contentView_.frame = CGRectMake(0.0,0.0, width, height);
}

#pragma mark - Status Methods

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if ([contentView_ respondsToSelector:@selector(setHighlighted:)]) {
        [(UIControl *)contentView_ setHighlighted:highlighted];
    }
}


@end
