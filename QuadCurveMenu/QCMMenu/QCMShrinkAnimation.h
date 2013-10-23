//
//  QCMShrinkAnimation.h
//  Nudge
//
//  Created by Franklin Webber on 3/16/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMAnimation.h"

@interface QCMShrinkAnimation : NSObject <QCMAnimation>

@property (readwrite, assign, nonatomic) CGFloat shrinkScale;

@end
