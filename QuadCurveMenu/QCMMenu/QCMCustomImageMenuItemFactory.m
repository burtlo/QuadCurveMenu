//
//  QCMCustomImageMenuItemFactory.m
//  QuadCurveMenu
//
//  Created by Franklin Webber on 9/2/13.
//
//

#import "QCMCustomImageMenuItemFactory.h"

@implementation QCMCustomImageMenuItemFactory

- (QCMMenuItem *)menuMainItemForMenu:(QCMMenu *)menu withDataObject:(id)dataObject {
	return [self menuItemForMenu:menu withDataObject:dataObject];
}

- (QCMMenuItem *)menuItemForMenu:(QCMMenu *)menu withDataObject:(id)dataObject {
    NSAssert(dataObject, @"Method argument 'dataObject' must not be nil");
	
    NSString *imageName = (NSString *)dataObject;

    UIImage *image = [UIImage imageNamed:imageName];
    
    AGMedallionView *medallionItem = [[AGMedallionView alloc] init];
	medallionItem.image = image;
	medallionItem.highlightedImage = nil;
    medallionItem.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    QCMMenuItem *item = [[QCMMenuItem alloc] initWithView:medallionItem];
    item.dataObject = dataObject;
    
    return item;
}

@end
