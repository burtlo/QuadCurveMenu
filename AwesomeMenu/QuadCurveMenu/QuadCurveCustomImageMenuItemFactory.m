//
//  QuadCurveCustomImageMenuItemFactory.m
//  AwesomeMenu
//
//  Created by Franklin Webber on 9/2/13.
//
//

#import "QuadCurveCustomImageMenuItemFactory.h"

@implementation QuadCurveCustomImageMenuItemFactory

- (QuadCurveMenuItem *)createMenuItemWithDataObject:(id)dataObject {
    
    NSString *imageName = (NSString *)dataObject;

    UIImage *image = [UIImage imageNamed:imageName];
    
    QuadCurveMenuItem *item = [[QuadCurveMenuItem alloc] initWithImage:image
                                                      highlightedImage:nil];
    
    [item setDataObject:dataObject];
    
    return item;
}

@end
