QuadCurveMenu is a menu with the same look as [the Path app's menu](https://path.com/)'s story menu.

![expand](https://dl.dropbox.com/u/1235674/quadcurve-expand.gif)
![expand-linear](https://dl.dropbox.com/u/1235674/quadcurve-linear.gif)

![custom-expand](https://dl.dropbox.com/u/1235674/quadcurve-custom-expand.gif)
![custom-selection](https://dl.dropbox.com/u/1235674/quadcurve-custom-selection.gif)
![custom-images](https://dl.dropboxusercontent.com/u/1235674/quadcurve-custom-images.gif)

This is a fork of [levey's AwesomeMenu](https://github.com/levey/AwesomeMenu). I proposed a pull request and this was not what the original author had intended to create. This fork has some notable differences that I outline in the [pull request](https://github.com/levey/AwesomeMenu/pull/15):

> I really love the menu and wanted to use any data source (not just an array), more touch events, and the ability to manipulate the images and animations. I also wanted the menu items to be able to hold some data object that I could store and retrieve on selection instead of relying on an index.

Ultimately this is a much more modular library that allows you to define new functionality for the menu without having to rip the guts out of the existing one.

* Componentized into multiple files

> QuadCurveMenu is defined in multiple files to separate concerns and make it easier to maintain and the code clearer. This does increase the burden when the code is included in a project.

* Converted project to ARC

* AppDelegate in the example is no longer responsible for the menu and an example view controller was created.

* Menu will generate delegate events for `willExpand`, `didExpand`,
`willClose`, and `didClose`.

* Menu will ask a delegate `shouldExpand` before expanding and `shouldClose` before closing

* Menu will generate events for tap (`didTapMenu`) and long press (`didLongPressMenu`)

* Menu is populated from a Data Source Delegate

* Menu is designed by a MenuItemFactory

* Menu is composed with individual, definable animations for expand, close, selected, unselected

* Menu animations are now in their own separate classes

* Menu can display menu items with a Radial, Linear or custom style

* Menu items will generate events for tap (`didTapMenuItem`) and long press (`didLongPressMenuItem`)

* Menu items are automatically medallionized (AGMedallionView) so custom *medallionized* images
  do not have to be created.

* Menu items are designed by a MenuItemFactory

* Menu items contain a dataObject

## Getting Started

### Default Usage

QuadCurveMenu defines a simple initializer that generates
a radial menu, 360 degrees, centered within the given frame
showing menu items for each element in the provided array.

```objc
@implementation AwesomeViewController

- (void)viewDidLoad {
  [super viewDidLoad]

  NSArray *menuItemArray = [NSArray arrayWithObjects:@"1",@"2",nil];

  QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds withArray:menuItemArray];

  [self.view addSubview:menu];
}

@end
```

### Custom Data Source

You may find an NSArray limiting so the menu can be defined with
a custom data source.

First you define a data source, or have an existing data source,
that adheres to the `QuadCurveDataSourceDelegate` protocol.

> By default when you use the array implementation it uses a `QuadCurveDefaultDataSource`
> which simply wraps an NSArray.

```objc
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
```

Creating a QuadCurveMenu with a custom data source:

```objc
@implementation AwesomeViewController

- (void)viewDidLoad {
  [super viewDidLoad]

  AwesomeDataSource *dataSource = [[AwesomeDataSource alloc] init];

  QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds dataSource:dataSource];

  [self.view addSubview:menu];
}

@end
```

### Event Delegate

Setup a delegate object, this will usually be the view controller showing the
QuadCurveMenu, that adheres to the `QuadCurveMenuDelegate` protocol.

```objc
@interface AwesomeViewController : UIViewController <QuadCurveMenuDelegate>

@end

@implementation AwesomeViewController

- (void)viewDidLoad {
  [super viewDidLoad]

  AwesomeDataSource *dataSource = [[AwesomeDataSource alloc] init];

  QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds dataSource:dataSource];

  menu.delegate = self;

  [self.view addSubview:menu];
}

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
    // Returning YES will allow the menu to close; NO to prevent it from closing.
    return YES;
}

- (BOOL)quadCurveMenuShouldExpand:(QuadCurveMenu *)menu {
    // Returning YES will allow the menu to expand; NO to prevent it from expanding.
    return YES;
}

@end
```

### Custom Menu Images and Menu Item Images

You can configure the look of the center, main menu item, and the menu items
that appear from the main menu.

> By default the QuadCurveMenu uses ```[QuadCurveDefaultMenuItemFactory defaultMainMenuItemFactory]```
> for the main menu and ```[QuadCurveDefaultMenuItemFactory defaultMenuItemFactory]``` for each menu item.
> These are defined to look like the path application.

You can define customized instances of `QuadCurveDefaultMenuItemFactory`:

```objc
@implementation AwesomeViewController

- (void)viewDidLoad {
  [super viewDidLoad]

  AwesomeDataSource *dataSource = [[AwesomeDataSource alloc] init];

  QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds dataSource:dataSource];

  menu.delegate = self;

  // Use a facebook center button for the menu

  [menu setMainMenuItemFactory:[[QuadCurveDefaultMenuItemFactory alloc] initWithImage:[UIImage imageNamed:@"facebook.png"] highlightImage:[UIImage imageNamed:nil]]];

  // Use an unknown user button for the menu items

  [menu setMenuItemFactory:[[QuadCurveDefaultMenuItemFactory alloc] initWithImage:[UIImage imageNamed:@"unknown-user.png"] highlightImage:[UIImage imageNamed:nil]]];

  [self.view addSubview:menu];
}
```

You can also define your own object that adheres to the protocol `QuadCurveMenuItemFactory`.

```objc
#pragma mark - QuadCurveMenuItemFactory Adherence

- (QuadCurveMenuItem *)createMenuItemWithDataObject:(id)dataObject {

    QuadCurveMenuItem *item = [[QuadCurveMenuItem alloc] initWithImage:image
                                                      highlightedImage:highlightImage
                                                          contentImage:contentImage
                                               highlightedContentImage:highlightContentImage];

    [item setDataObject:dataObject];

    return item;
}
```

### Custom Menu Directions

By default QuadCurveMenu displays in a 360 degree radial menu.
This can be customized by confuring an existing menu directory
or defining a custom `QuadCurveMotionDirector`

> This is a departure from the original source which defined a number of attributes on the
> menu which controlled the layout.

#### QuadCurveRadialDirector

You can define a a custom radial director with the options:

* `rotateAngle` - initial starting angle of the menu (default: 0 degrees)
* `menuWholeAngle` - the total available angle that the menu items will be displayed (default: 360 degrees)

* `endRadius` - the final distance from the main menu center (where the menu items will sit)
* `nearRadius` - the closest distance from the main menu center that the menu items will travel
* `farRadius` - the furthest distance from the main menu center that the menu items will travel

#### QuadCurveLinearDirector

You can define a custom linear director with the options:

* `angle` - the angle at which to display the menu items
* `padding` - the space between each menu item

#### Custom QuadCurveMotionDirector

If a radial or linear layout is not powerful enough, you can define
a custom director that adheres to the `QuadCurveMotionDirector` interface:

```objc
@protocol QuadCurveMotionDirector <NSObject>

- (void)positionMenuItem:(QuadCurveMenuItem *)item
                 atIndex:(int)index
                 ofCount:(int)count
                fromMenu:(QuadCurveMenuItem *)mainMenuItem;

@end
```

### Custom Animations

Several of the animations are customizable through properties. Viewing the
example project you should see an __Animations__ group which contains the
default animations used in the application. You can customize them there or
define your own and set them through properties on the `QuadCurveMenu`.

Here is an example of swapping the default _selected_ and _unselected_
animations:

```objc
menu.selectedAnimation = [[QuadCurveShrinkAnimation alloc] init]
menu.unselectedanimation = [[QuadCurveBlowupAnimation alloc] init]
```

An animation is an object that adheres to the protocol `QuadCurveAnimation`.

```objc
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
```

The name is used as the name for the animation within the layer. The animation
itself is called with the `QuadCurveMenuItem` and should return the animation
group that will be performed.