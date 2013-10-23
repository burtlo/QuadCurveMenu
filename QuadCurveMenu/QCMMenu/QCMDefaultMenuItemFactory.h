//
//  QCMDefaultMenuItemFactory.h
//  Nudge
//
//  Created by Franklin Webber on 3/19/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMMenu.h"

@interface QCMDefaultMenuItemFactory : NSObject <QCMMenuItemFactory>

- (id)initWithImage:(UIImage *)image 
     highlightImage:(UIImage *)highlightImage;
+ (instancetype)factoryWithImage:(UIImage *)image
     highlightImage:(UIImage *)highlightImage;

+ (instancetype)defaultMenuItemFactory;
+ (instancetype)defaultMainMenuItemFactory;

@end
