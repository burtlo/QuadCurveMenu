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

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;

@property (nonatomic, readonly) AGMedallionView *contentImageView;

- (void)longPressOnMenuItem:(UIGestureRecognizer *)sender;
- (void)singleTapOnMenuItem:(UIGestureRecognizer *)sender;

@end

@implementation QuadCurveMenuItem

@synthesize dataObject;

@synthesize contentImageView = contentImageView_;

@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize nearPoint = _nearPoint;
@synthesize farPoint = _farPoint;
@synthesize delegate  = delegate_;

@dynamic image;
@dynamic highlightedImage;

#pragma mark - Initialization

- (id)initWithImage:(UIImage *)_image 
   highlightedImage:(UIImage *)_highlightedImage {
    
    if (self = [super init]) {
        
        self.userInteractionEnabled = YES;
        
        contentImageView_ = [[AGMedallionView alloc] init];
        [contentImageView_ setImage:_image];
        [contentImageView_ setHighlightedImage:_highlightedImage];
        
        [self addSubview:contentImageView_];
        self.frame = CGRectMake(self.center.x - self.image.size.width/2,self.center.y - self.image.size.height/2,self.image.size.width, self.image.size.height);
        
        
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
    
    self.frame = CGRectMake(self.center.x - self.image.size.width/2,self.center.y - self.image.size.height/2,self.image.size.width, self.image.size.height);
    
    float width = self.image.size.width;
    float height = self.image.size.height;
    
    contentImageView_.frame = CGRectMake(0.0,0.0, width, height);
}

#pragma mark - Image and HighlightImage

- (void)setImage:(UIImage *)image {
    contentImageView_.image = image;
}

- (UIImage *)image {
    return contentImageView_.image;
}

- (void)setHighlightedImage:(UIImage *)highlightedImage {
    contentImageView_.highlightedImage = highlightedImage;
}

- (UIImage *)highlightedImage {
    return contentImageView_.highlightedImage;
}



#pragma mark - Status Methods

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [contentImageView_ setHighlighted:highlighted];
}


@end
