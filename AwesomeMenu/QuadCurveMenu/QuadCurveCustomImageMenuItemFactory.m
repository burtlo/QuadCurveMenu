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
    NSAssert(dataObject, @"Method argument 'dataObject' must not be nil");
	
    NSString *imageName = (NSString *)dataObject;

    UIImage *image = [UIImage imageNamed:imageName];
    
    AGMedallionView *medallionItem = [AGMedallionView new];
    medallionItem = [[AGMedallionView alloc] init];
	medallionItem.image = image;
	medallionItem.highlightedImage = nil;
    medallionItem.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    QuadCurveMenuItem *item = [[QuadCurveMenuItem alloc] initWithView:medallionItem];
    item.dataObject = dataObject;
    
    return item;
}

@end
