//
//  QuadCurveMenuItem.m
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//

#import "QuadCurveMenuItem.h"

static inline CGRect ScaleRect(CGRect rect, CGFloat n) {return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);}

@interface QuadCurveMenuItem ()

@property (readwrite, assign, nonatomic) BOOL delegateHasLongPressed;
@property (readwrite, assign, nonatomic) BOOL delegateHasTapped;

@property (readwrite, strong, nonatomic) UIView *contentView;

- (void)longPressOnMenuItem:(UIGestureRecognizer *)sender;
- (void)singleTapOnMenuItem:(UIGestureRecognizer *)sender;

@end

@implementation QuadCurveMenuItem

#pragma mark - Initialization

- (id)initWithView:(UIView *)view {
    
    if (self = [super init]) {
        
        self.userInteractionEnabled = YES;
        
        self.contentView = view;
        [self addSubview:view];
        self.frame = CGRectMake(self.center.x - self.contentView.bounds.size.width/2,self.center.y - view.bounds.size.height/2,view.bounds.size.width, view.bounds.size.height);
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnMenuItem:)];
        
        [self addGestureRecognizer:longPressGesture];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapOnMenuItem:)];
        
        [self addGestureRecognizer:singleTapGesture];
		
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - Delegate

- (void)setDelegate:(id<QuadCurveMenuItemEventDelegate>)delegate {
    _delegate = delegate;
    self.delegateHasLongPressed = [delegate respondsToSelector:@selector(quadCurveMenuItemLongPressed:)];
    self.delegateHasTapped = [delegate respondsToSelector:@selector(quadCurveMenuItemTapped:)];
}

#pragma mark - Gestures

- (void)longPressOnMenuItem:(UILongPressGestureRecognizer *)sender {
    if (self.delegateHasLongPressed) {
        [self.delegate quadCurveMenuItemLongPressed:self];
    }
}

- (void)singleTapOnMenuItem:(UITapGestureRecognizer *)sender {
    if (self.delegateHasTapped) {
        [self.delegate quadCurveMenuItemTapped:self];
    }
}

#pragma mark - UIView's methods

- (void)layoutSubviews {
    [super layoutSubviews];
    
	UIView *contentView = self.contentView;
    self.frame = CGRectMake(self.center.x - contentView.bounds.size.width/2,self.center.y - contentView.bounds.size.height/2,contentView.bounds.size.width, contentView.bounds.size.height);
    
    CGFloat width = contentView.bounds.size.width;
    CGFloat height = contentView.bounds.size.height;
    
    contentView.frame = CGRectMake(0.0,0.0, width, height);
}

#pragma mark - Status Methods

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if ([self.contentView respondsToSelector:@selector(setHighlighted:)]) {
		((UIControl *)self.contentView).highlighted = highlighted;
    }
}


@end
