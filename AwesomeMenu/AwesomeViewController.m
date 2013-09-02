//
//  AwesomeViewController.m
//  AwesomeMenu
//
//  Created by Franklin Webber on 3/28/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "AwesomeViewController.h"
#import "AwesomeDataSource.h"
#import "QuadCurveDefaultMenuItemFactory.h"
#import "QuadCurveLinearDirector.h"

@interface AwesomeViewController ()

@end

@implementation AwesomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"classy_fabric.png"]]];
    
    //
    // BUILDING A MENU WITH AN ARRAY
    //
    // The original menu provided support for quickly creating a menu with an array of objects. This is still supported with
    // this initialization. This is ideal if you have a simple set of data and no real need of using a DataSource.
    //
    
    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds withArray:[NSArray arrayWithObjects:@"1",@"2",@"3", nil]];
    
    //
    // BUILDING A MENU WITH A DATA SOURCE
    // The data source is really overkill if you have a simple list of items. The ideal use for the data source is if
    // you want to load the data from some external resource like from a database or from an api.
    
//    AwesomeDataSource *dataSource = [[AwesomeDataSource alloc] init];
//    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds dataSource:dataSource];
    
    
    //
    // LINEAR MENU
    //
    // Examples of replacing the existing menu layout with a linear director which will expand the menu items in a straight line.
    // Uncomment the various version to see each of them in action. Several of these will run off the screen because of the positioning
    // of the main menu item being in the center.
    //
    
    // Change the menu to be vertical (expanding up)
//    [menu setMenuDirector:[[QuadCurveLinearDirector alloc] initWithAngle:M_PI/2 andPadding:15.0]];
    
    // Change the menu to be vertical (expanding down)
//    [menu setMenuDirector:[[QuadCurveLinearDirector alloc] initWithAngle:(3 * M_PI/2) andPadding:15.0]];

    // Change the menu to be horizontal (expanding to the right)
//    [menu setMenuDirector:[[QuadCurveLinearDirector alloc] initWithAngle:0 andPadding:15.0]];

    // Change the menu to be horizontal (expanding to the left)
//    [menu setMenuDirector:[[QuadCurveLinearDirector alloc] initWithAngle:M_PI andPadding:15.0]];
    
    //
    // CUSTOM IMAGES
    //
    // This is the first example of changing the main menu item and the sub menu items. Here we are replacing the main menu item with a facebook image
    // each of the various sub menuitems with an unknown user image.
    //
    // Uncomment the lines below to see the override the default functionality.
    //
    
//    [menu setMainMenuItemFactory:[[QuadCurveDefaultMenuItemFactory alloc] initWithImage:[UIImage imageNamed:@"facebook.png"] highlightImage:[UIImage imageNamed:nil]]];
//    [menu setMenuItemFactory:[[QuadCurveDefaultMenuItemFactory alloc] initWithImage:[UIImage imageNamed:@"unknown-user.png"] highlightImage:[UIImage imageNamed:nil]]];
    
    
    menu.delegate = self;
	[self.view addSubview:menu];
	
}

#pragma mark - QuadCurveMenuDelegate Adherence

- (void)quadCurveMenu:(QuadCurveMenu *)menu didTapMenu:(QuadCurveMenuItem *)mainMenuItem {
    NSLog(@"Menu - Tapped");
}

- (void)quadCurveMenu:(QuadCurveMenu *)menu didLongPressMenu:(QuadCurveMenuItem *)mainMenuItem {
    NSLog(@"Menu - Long Pressed");
}

- (void)quadCurveMenu:(QuadCurveMenu *)menu didTapMenuItem:(QuadCurveMenuItem *)menuItem {
    NSLog(@"Menu Item (%@) - Tapped",menuItem.dataObject);
}

- (void)quadCurveMenu:(QuadCurveMenu *)menu didLongPressMenuItem:(QuadCurveMenuItem *)menuItem {
    NSLog(@"Menu Item (%@) - Long Pressed",menuItem.dataObject);
}

- (void)quadCurveMenuWillExpand:(QuadCurveMenu *)menu {
    NSLog(@"Menu - Will Expand");
}

- (void)quadCurveMenuDidExpand:(QuadCurveMenu *)menu {
    NSLog(@"Menu - Did Expand");
}

- (void)quadCurveMenuWillClose:(QuadCurveMenu *)menu {
    NSLog(@"Menu - Will Close");
}

- (void)quadCurveMenuDidClose:(QuadCurveMenu *)menu {
    NSLog(@"Menu - Did Close");
}

- (BOOL)quadCurveMenuShouldClose:(QuadCurveMenu *)menu {
    return YES;
}

- (BOOL)quadCurveMenuShouldExpand:(QuadCurveMenu *)menu {
    return YES;
}


@end
