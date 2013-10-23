//
//  QuadCurveDefaultMenuItemFactory.h
//  Nudge
//
//  Created by Franklin Webber on 3/19/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveMenu.h"

@interface QuadCurveDefaultMenuItemFactory : NSObject <QuadCurveMenuItemFactory>

- (id)initWithImage:(UIImage *)image 
     highlightImage:(UIImage *)highlightImage;

+ (instancetype)defaultMenuItemFactory;
+ (instancetype)defaultMainMenuItemFactory;

@end
