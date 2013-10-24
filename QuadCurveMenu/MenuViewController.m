//
//  MenuViewController.m
//  QuadCurveMenu
//
//  Created by Franklin Webber on 3/28/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuDataSource.h"
#import "MenuItemFactory.h"
#import "QCMDefaultMenuItemFactory.h"
#import "QCMDefaultDataSource.h"
#import "QCMLinearDirector.h"
#import "QCMRadialDirector.h"

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"classy_fabric.png"]];
    
    //
    // BUILDING A MENU WITH AN ARRAY
    //
    // The original menu provided support for quickly creating a menu with an array of objects. This is still supported with
    // this initialization. This is ideal if you have a simple set of data and no real need of using a DataSource.
    //
    
	NSArray *items = @[@"1", @"2", @"3", @"4", @"5", @"6"];
	
    QCMMenu *menu = [[QCMMenu alloc] initWithFrame:self.view.bounds withArray:items];
    
    //
    // BUILDING A MENU WITH CUSTOM IMAGES
    //
    // Sometimes custom getting a menu up and running with different images is what you want. An initialization
    // for that exist to allow you to quickly create a menu with custom images. This is really using
    // just a shortcut way to compose a menu together so you don't have to understand or use the
    // menu item factories which tend to be the most confusing part of the library.
    //
    // NOTE: Creation this way is not as flexible as the data source for the menu items becomes the list of images. So all those events
    // when the menu item are pressed will report back to you the image. A more advanced way would be to define your own MenuItem Factory
    // which inspects the data source item for a property or value which would contain the image information.
    //
    
//    QCMMenu *menu = [[QCMMenu alloc] initWithFrame:self.view.bounds mainMenuImage:@"facebook.png" menuItemImageArray:[NSArray arrayWithObjects:@"edmundo.jpeg",@"hector.jpeg",@"paul.jpeg", nil]];

    // Remove medallion effect from subitems
//    menu.menuItemFactory = [[MenuItemFactory alloc] init];
    
    
    //
    // BUILDING A MENU WITH A DATA SOURCE
    //
    // The data source is really overkill if you have a simple list of items. The ideal use for the data source is if
    // you want to load the data from some external resource like from a database or from an api.
    //
    // The example data source here is really just an array but in a real life situation you would pull the data from
    // the source.
    //
    
//    MenuDataSource *dataSource = [[MenuDataSource alloc] init];
//    QCMMenu *menu = [[QCMMenu alloc] initWithFrame:self.view.bounds dataSource:dataSource];
    
        
    //
    // LINEAR MENU
    //
    // Examples of replacing the existing menu layout with a linear director which will expand the menu items in a straight line.
    // Uncomment the various version to see each of them in action. Several of these will run off the screen because of the positioning
    // of the main menu item being in the center.
    //
    
    // Change the menu to be vertical (expanding up)
//    menu.menuDirector = [[QCMLinearDirector alloc] initWithAngle:M_PI/2 andPadding:15.0];
    
    // Change the menu to be vertical (expanding down)
//    menu.menuDirector = [[QCMLinearDirector alloc] initWithAngle:(3 * M_PI/2) andPadding:15.0];

    // Change the menu to be horizontal (expanding to the right)
//    menu.menuDirector = [[QCMLinearDirector alloc] initWithAngle:0 andPadding:15.0];

    // Change the menu to be horizontal (expanding to the left)
//    menu.menuDirector = [[QCMLinearDirector alloc] initWithAngle:M_PI andPadding:15.0];
    
    //
    // CUSTOM IMAGES
    //
    // This is the first example of changing the main menu item and the sub menu items. Here we are replacing the main menu item with a facebook image
    // each of the various sub menuitems with an unknown user image.
    //
    // Uncomment the lines below to see the override the default functionality.
    //
    
//    menu.mainMenuItemFactory = [[QCMDefaultMenuItemFactory alloc] initWithImage:[UIImage imageNamed:@"facebook.png"] highlightImage:[UIImage imageNamed:nil]];
//    menu.menuItemFactory = [[QCMDefaultMenuItemFactory alloc] initWithImage:[UIImage imageNamed:@"unknown-user.png"] highlightImage:[UIImage imageNamed:nil]];

	//
	// OPTIMAL RADIUS FOR RADIAL MENU
	//
	// QCMRadialDirector provides a method for calculating the required radius for a given number of items of uniform size with spacing:
	
//	CGFloat radius = [QCMRadialDirector defaultRadius];
//	CGFloat arcAngle = [QCMRadialDirector defaultArcAngle];
//	[QCMRadialDirector getRecommendedRadius:&radius
//						forMenuWithArcAngle:arcAngle
//							  numberOfItems:items.count
//									 ofSize:CGSizeMake(50.0, 50.0)
//									spacing:10.0];
//	
//	((QCMRadialDirector *)menu.menuDirector).radius = radius;
	
	//
	// CLIPPED RADIAL MENU
	//
	// QCMRadialDirector provides a method for optimal arcAngle and startAngle for a given position in a clipping rect:
	
//	CGFloat radius = [QCMRadialDirector defaultRadius];
//	CGPoint centerPoint = CGPointMake(radius * 0.5, radius * 0.5);
//	menu = [[QCMMenu alloc] initWithFrame:self.view.bounds
//							  centerPoint:centerPoint
//							   dataSource:[[QCMDefaultDataSource alloc] initWithArray:items]
//						  mainMenuFactory:[QCMDefaultMenuItemFactory defaultMainMenuItemFactory]
//						  menuItemFactory:[QCMDefaultMenuItemFactory defaultMenuItemFactory]];
//	CGFloat arcAngle = [QCMRadialDirector defaultArcAngle];
//	CGFloat startAngle = [QCMRadialDirector defaultStartAngle];
//	
//	BOOL clipped = [QCMRadialDirector getRecommendedArcAngle:&arcAngle
//												  startAngle:&startAngle
//										   forMenuWithCenter:centerPoint
//												   andRadius:radius
//													  inRect:self.view.bounds];
//	CGFloat marginAngle = (clipped) ? 0.2 : 0.0;
//	QCMRadialDirector *director = [QCMRadialDirector directorWithArcAngle:arcAngle - (2 * marginAngle)
//															   startAngle:startAngle + marginAngle];
//	menu.menuDirector = director;
    
    menu.delegate = self;
	[self.view addSubview:menu];
}

#pragma mark - QCMMenuDelegate Adherence

- (void)QCMMenu:(QCMMenu *)menu didTapMenu:(QCMMenuItem *)mainMenuItem {
    NSLog(@"Menu - Tapped");
}

- (void)QCMMenu:(QCMMenu *)menu didLongPressMenu:(QCMMenuItem *)mainMenuItem {
    NSLog(@"Menu - Long Pressed");
}

- (void)QCMMenu:(QCMMenu *)menu didTapMenuItem:(QCMMenuItem *)menuItem {
    NSLog(@"Menu Item (%@) - Tapped",menuItem.dataObject);
}

- (void)QCMMenu:(QCMMenu *)menu didLongPressMenuItem:(QCMMenuItem *)menuItem {
    NSLog(@"Menu Item (%@) - Long Pressed",menuItem.dataObject);
}

- (void)QCMMenuWillExpand:(QCMMenu *)menu {
    NSLog(@"Menu - Will Expand");
}

- (void)QCMMenuDidExpand:(QCMMenu *)menu {
    NSLog(@"Menu - Did Expand");
}

- (void)QCMMenuWillClose:(QCMMenu *)menu {
    NSLog(@"Menu - Will Close");
}

- (void)QCMMenuDidClose:(QCMMenu *)menu {
    NSLog(@"Menu - Did Close");
}

- (BOOL)QCMMenuShouldClose:(QCMMenu *)menu {
    return YES;
}

- (BOOL)QCMMenuShouldExpand:(QCMMenu *)menu {
    return YES;
}


@end
