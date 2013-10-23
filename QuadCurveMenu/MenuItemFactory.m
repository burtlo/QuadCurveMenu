//
//  MenuItemFactory.m
//  QuadCurveMenu
//
//  Created by Franklin Webber on 3/28/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "MenuItemFactory.h"

@implementation MenuItemFactory

- (QCMMenuItem *)createMenuItemWithDataObject:(id)dataObject {
    NSString *imageName = (NSString *)dataObject;
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageItem = [[UIImageView alloc] initWithImage:image];
    imageItem.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    QCMMenuItem *item = [[QCMMenuItem alloc] initWithView:imageItem];
    item.dataObject = dataObject;
    return item;
}

@end
