//
//  QCMDefaultMenuItemFactory.m
//  Nudge
//
//  Created by Franklin Webber on 3/19/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QCMDefaultMenuItemFactory.h"

@interface QCMDefaultMenuItemFactory ()

@property (readwrite, strong, nonatomic) UIImage *image;
@property (readwrite, strong, nonatomic) UIImage *highlightImage;

@end

@implementation QCMDefaultMenuItemFactory

#pragma mark - Initialization

- (id)initWithImage:(UIImage *)image
	 highlightImage:(UIImage *)highlightImage {
	self = [super init];
	if (self) {
		self.image = image;
		self.highlightImage = highlightImage;
	}
	return self;
}

+ (instancetype)factoryWithImage:(UIImage *)image
		highlightImage:(UIImage *)highlightImage {
	return [[self alloc] initWithImage:image highlightImage:highlightImage];
}

+ (instancetype)defaultMenuItemFactory {
	return [[self alloc] initWithImage:[UIImage imageNamed:@"icon-star.jpeg" ]
						highlightImage:nil];
}

+ (instancetype)defaultMainMenuItemFactory {
	return [[self alloc] initWithImage:[UIImage imageNamed:@"icon-plus.jpeg"]
						highlightImage:nil];
}

#pragma mark - QCMMenuItemFactory Adherence

- (QCMMenuItem *)menuMainItemForMenu:(QCMMenu *)menu withDataObject:(id)dataObject {
	return [self menuItemForMenu:menu withDataObject:dataObject];
}

- (QCMMenuItem *)menuItemForMenu:(QCMMenu *)menu withDataObject:(id)dataObject {
	AGMedallionView *medallionItem = [[AGMedallionView alloc] init];
	medallionItem.image = self.image;
	medallionItem.highlightedImage = self.highlightImage;
	CGSize size = self.image.size;
	medallionItem.frame = CGRectMake(0, 0, size.width, size.height);
	
	QCMMenuItem *item = [[QCMMenuItem alloc] initWithView:medallionItem];
	item.dataObject = dataObject;
	
	return item;
}

@end
