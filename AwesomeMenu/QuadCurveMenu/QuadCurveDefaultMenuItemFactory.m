//
//  QuadCurveDefaultMenuItemFactory.m
//  Nudge
//
//  Created by Franklin Webber on 3/19/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveDefaultMenuItemFactory.h"

@interface QuadCurveDefaultMenuItemFactory ()

@property (readwrite, strong, nonatomic) UIImage *image;
@property (readwrite, strong, nonatomic) UIImage *highlightImage;

@end

@implementation QuadCurveDefaultMenuItemFactory

#pragma mark - Initialization

- (id)initWithImage:(UIImage *)image
     highlightImage:(UIImage *)highlightImage {
    NSAssert(image, @"Method argument 'image' must not be nil");
    self = [super init];
    if (self) {
        self.image = image;
        self.highlightImage = highlightImage;
    }
    return self;
}

+ (instancetype)factoryWithImage:(UIImage *)image
		highlightImage:(UIImage *)highlightImage {
	return [[self alloc] initWithImage:image highlightImage:highlightImage];
}

+ (instancetype)defaultMenuItemFactory {
    return [[self alloc] initWithImage:[UIImage imageNamed:@"icon-star.jpeg" ]
						highlightImage:nil];
}

+ (instancetype)defaultMainMenuItemFactory {
    return [[self alloc] initWithImage:[UIImage imageNamed:@"icon-plus.jpeg"]
						highlightImage:nil];
}

#pragma mark - QuadCurveMenuItemFactory Adherence

- (QuadCurveMenuItem *)createMenuItemWithDataObject:(id)dataObject {	
    AGMedallionView *medallionItem = [[AGMedallionView alloc] init];
	medallionItem.image = self.image;
    medallionItem.highlightedImage = self.highlightImage;
	CGSize size = self.image.size;
    medallionItem.frame = CGRectMake(0, 0, size.width, size.height);
    
    QuadCurveMenuItem *item = [[QuadCurveMenuItem alloc] initWithView:medallionItem];
    item.dataObject = dataObject;
    
    return item;
}

@end
