//
//  AGMedallionView.h
//  AGMedallionView
//
//  Created by Artur Grigor on 1/23/12.
//  Copyright (c) 2012 - 2013 Artur Grigor. All rights reserved.
//
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

#import <UIKit/UIKit.h>

@interface AGMedallionView : UIView

@property (readwrite, strong, nonatomic) UIImage *image;
@property (readwrite, strong, nonatomic) UIImage *highlightedImage;

@property (readwrite, strong, nonatomic) UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (readwrite, assign, nonatomic) CGFloat borderWidth UI_APPEARANCE_SELECTOR;
@property (readwrite, strong, nonatomic) UIColor *shadowColor UI_APPEARANCE_SELECTOR;
@property (readwrite, assign, nonatomic) CGSize shadowOffset UI_APPEARANCE_SELECTOR;
@property (readwrite, assign, nonatomic) CGFloat shadowBlur UI_APPEARANCE_SELECTOR;

@property (readwrite, assign, nonatomic) BOOL highlighted;

@property (readwrite, strong, nonatomic) UIColor *progressColor;
@property (readwrite, assign, nonatomic) CGFloat progress;

@end

