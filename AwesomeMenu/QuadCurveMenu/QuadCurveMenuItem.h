//
//  QuadCurveMenuItem.h
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGMedallionView.h"
#import "QuadCurveMenuItemEventDelegate.h"

@protocol QuadCurveMenuItemEventDelegate;
@protocol QuadCurveMenuItemFactory;

@interface QuadCurveMenuItem : UIControl

@property (readwrite, strong, nonatomic) id dataObject;

@property (readwrite, assign, nonatomic) CGPoint startPoint;
@property (readwrite, assign, nonatomic) CGPoint endPoint;
@property (readwrite, assign, nonatomic) CGPoint nearPoint;
@property (readwrite, assign, nonatomic) CGPoint farPoint;

@property (readwrite, strong, nonatomic) id<QuadCurveMenuItemEventDelegate> delegate;

- (id)initWithView:(UIView *)view;

@end