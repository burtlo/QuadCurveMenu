//
//  QCMDataSourceDelegate.h
//  QuadCurveMenu
//
//  Created by Franklin Webber on 4/2/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

@class QCMMenu;

@protocol QCMDataSourceDelegate <NSObject>

- (NSUInteger)numberOfItemsInMenu:(QCMMenu *)menu;
- (id)dataObjectAtIndex:(NSUInteger)itemIndex inMenu:(QCMMenu *)menu;

@end
