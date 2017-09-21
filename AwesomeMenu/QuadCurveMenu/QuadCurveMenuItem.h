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

@property (nonatomic, strong) id dataObject;

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGPoint nearPoint;
@property (nonatomic) CGPoint farPoint;

@property (nonatomic, strong) id<QuadCurveMenuItemEventDelegate> delegate;

- (id)initWithView:(UIView *)view;

@end
