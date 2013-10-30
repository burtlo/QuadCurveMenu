//
//  QCMItemExpandAnimation.h
//  Nudge
//
//  Created by Franklin Webber on 3/16/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMAnimation.h"

@interface QCMItemExpandAnimation : NSObject <QCMAnimation>

@property (readwrite, assign, nonatomic) CGFloat rotation;

@property (readwrite, assign, nonatomic) BOOL animatesRotation;
@property (readwrite, assign, nonatomic) BOOL animatesOpacity;

@end
