//
//  QCMDefaultDataSource.h
//  QuadCurveMenu
//
//  Created by Franklin Webber on 3/28/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCMMenu.h"

@interface QCMDefaultDataSource : NSObject <QCMDataSourceDelegate>

- (id)initWithArray:(NSArray *)array;
+ (instancetype)dataSourceWithArray:(NSArray *)array;

@end
