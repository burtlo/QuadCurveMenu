//
//  QuadCurveDefaultMenuItemFactory.m
//  Nudge
//
//  Created by Franklin Webber on 3/19/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveDefaultMenuItemFactory.h"

@interface QuadCurveDefaultMenuItemFactory () {
    UIImage *image;
    UIImage *highlightImage;
}

@end

@implementation QuadCurveDefaultMenuItemFactory

#pragma mark - Initialization

- (id)initWithImage:(UIImage *)_image 
     highlightImage:(UIImage *)_highlightImage {
    
    self = [super init];
    if (self) {
        
        image = _image;
        highlightImage = _highlightImage;
        
    }
    return self;
}

+ (id)defaultMenuItemFactory {
    
    return [[self alloc] initWithImage:[UIImage imageNamed:@"icon-star.png" ]
                                           highlightImage:nil];
}

+ (id)defaultMainMenuItemFactory {
    
    return [[self alloc] initWithImage:[UIImage imageNamed:@"icon-plus.png"]
                            highlightImage:nil];

}

#pragma mark - QuadCurveMenuItemFactory Adherence

- (QuadCurveMenuItem *)createMenuItemWithDataObject:(id)dataObject {
    
    AGMedallionView *medallionItem = [AGMedallionView new];
    medallionItem = [[AGMedallionView alloc] init];
    [medallionItem setImage:image];
    [medallionItem setHighlightedImage:highlightImage];
    medallionItem.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    QuadCurveMenuItem *item = [[QuadCurveMenuItem alloc] initWithView:medallionItem];
    
    [item setDataObject:dataObject];
    
    return item;
}

@end
