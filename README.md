QuadCurveMenu is a menu with the same look as [the Path app's menu](https://path.com/)'s story menu.

This is a fork of [levey's AwesomeMenu](https://github.com/levey/AwesomeMenu). I proposed a pull request and this was not what the original author had intended to create. This fork has some notable differences that I outline in the [pull request](https://github.com/levey/AwesomeMenu/pull/15):

> I really love the menu and wanted to use any data source (not just an array), more touch events, and the ability to manipulate the images and animations. I also wanted the menu items to be able to hold some data object that I could store and retrieve on selection instead of relying on an index.

Ultimately this is a much more modular library that allows you to define new functionality for the menu without having to rip the guts out of the existing one.

* Converted project to ARC

* AppDelegate in the example is no longer responsible for the menu and an example view controller was created.

* Menu will generate delegate events for will expand, did expand,
will close, and did close.

* Menu will ask a delegate should expand and should close

* Menu will generate events for tap and long press

* Menu is populated from a Data Source Delegate

* Menu is designed by a MenuItemFactory

* Menu is composed with animations for expand, close, selected, unselected

* Menu animations are now in their own separate classes

* Menu items will generate events for tap and long press

* Menu items are designed by a MenuItemFactory

* Menu items contain a dataObject

* Radial / Linear menu styles that is easily re-definable.

## Getting Started

### Data Source

First you define a data source, or have an existing data source,
that adheres to the `QuadCurveDataSourceDelegate` protocol.

    @interface AwesomeDataSource : NSObject <QuadCurveDataSourceDelegate> {
        NSMutableArray *dataItems;
    }
    @end

    @implementation AwesomeDataSource

    - (id)init {
        self = [super init];
        if (self) {
            dataItems = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
        }
        return self;
    }

    #pragma mark - QuadCurveDataSourceDelegate Adherence

    - (int)numberOfMenuItems {
        return [dataItems count];
    }

    - (id)dataObjectAtIndex:(NSInteger)itemIndex {
        return [dataItems objectAtIndex:itemIndex];
    }
    
### Event Delegate

Setup a delegate object, this will usually be the view controller showing the
QuadCurveMenu, that adheres to the `QuadCurveMenuDelegate` protocol.

    @interface AwesomeViewController : UIViewController <QuadCurveMenuDelegate>

    @end

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

### Creating the Menu

Then within your view controller define the `QuadCurveMenu` with some bounds, 
your data source, and your event delegate.


    AwesomeDataSource *dataSource = [[AwesomeDataSource alloc] init];

    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds  dataSource:dataSource];

    [menu setDelegate:self]
    [self.view addSubview:menu];

### Configuring the Menu

You can also use menu options:

to locate the center of "Add" button:

	menu.startPoint = CGPointMake(160.0, 240.0);

to set the rotate angle:

	menu.rotateAngle = 0.0;

to set the whole menu angle:

	menu.menuWholeAngle = M_PI * 2;

to set the delay of every menu flying out animation:

	menu.timeOffset = 0.036f;

to adjust the bounce animation:

	menu.farRadius = 140.0f;
	menu.nearRadius = 110.0f;

to set the distance between the "Add" button and Menu Items:

	menu.endRadius = 120.0f;


#### Changing the Images

You can configure the look of the center, main menu item, and the menu items 
that appear from the main menu. To do that you define an object that adheres 
to the protocol `QuadCurveMenuItemFactory`.


    #pragma mark - QuadCurveMenuItemFactory Adherence

    - (QuadCurveMenuItem *)createMenuItemWithDataObject:(id)dataObject {

        QuadCurveMenuItem *item = [[QuadCurveMenuItem alloc] initWithImage:image 
                                                          highlightedImage:highlightImage
                                                              contentImage:contentImage 
                                                   highlightedContentImage:highlightContentImage];

        [item setDataObject:dataObject];

        return item;
    }
    
Create an instance of that object and assign it to the QuadCurveMenu property `mainMenuItemFactory` or `menuItemFactory`.

    id<QuadCurveMenuItemFactory> customMenuItemFactory = [[MyCustomMenuItemFactory alloc] init];

    menu.mainMenuItemFactory = customMenuItemFactory;
    menu.menuItemFactory = customMenuItemFactory;
    
By default the QuadCurveMenu uses `QuadCurveDefaultMenuItemFactory`. The main 
menu item is set by:

    [QuadCurveDefaultMenuItemFactory defaultMainMenuItemFactory]

Each sub menu item are created by:

    [QuadCurveDefaultMenuItemFactory defaultMenuItemFactory]
    

#### Changing Animations

Several of the animations are customizable through properties. Viewing the
example project you should see an __Animations__ group which contains the 
default animations used in the application. You can customize them there or
define your own and set them through properties on the `QuadCurveMenu`.

Here is an example of swapping the default _selected_ and _unselected_ 
animations:

    menu.selectedAnimation = [[QuadCurveShrinkAnimation alloc] init]
    menu.unselectedanimation = [[QuadCurveBlowupAnimation alloc] init]

An animation is an object that adheres to the protocol `QuadCurveAnimation`. 

    - (NSString *)animationName {
        return @"blowup";
    }

    - (CAAnimationGroup *)animationForItem:(QuadCurveMenuItem *)item {
    
        CGPoint point = item.center;
    
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point], nil];
        positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil]; 
    
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
        animationgroup.duration = 0.3f;
    
        return animationgroup;

    }

The name is used as the name for the animation within the layer. The animation 
itself is called with the `QuadCurveMenuItem` and should return the animation
group that will be performed.

![screenshots](http://k.minus.com/ib1kHc4lnLB8bd.gif) ![screenshots](http://k.minus.com/iovTFVTQQ192K.gif) ![screenshots](http://k.minus.com/i4BrO2tfCJxzk.gif)
