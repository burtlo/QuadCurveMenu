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

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;

@property (nonatomic, strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *shadowColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGSize shadowOffset UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat shadowBlur UI_APPEARANCE_SELECTOR;

@property (nonatomic) BOOL highlighted;

@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic) CGFloat progress;

@end

