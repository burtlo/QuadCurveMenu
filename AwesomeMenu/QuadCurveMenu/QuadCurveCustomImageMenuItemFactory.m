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
    
    AGMedallionView *medallionItem = [AGMedallionView new];
    medallionItem = [[AGMedallionView alloc] init];
    [medallionItem setImage:image];
    [medallionItem setHighlightedImage:nil];
    medallionItem.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    QuadCurveMenuItem *item = [[QuadCurveMenuItem alloc] initWithView:medallionItem];
    
    [item setDataObject:dataObject];
    
    return item;
}

@end
