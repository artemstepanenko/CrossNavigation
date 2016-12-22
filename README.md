# CrossNavigation

if you inherit your view controllers from `CNViewController`, `CNNavigationController`, or `CNTabBarController`, you'll be able to push them to the stack not just to right side (as you do if you use `UINavigationController`), but to any of four: left, top, right, bottom. Supports autorotations.

- [Auto-transitions](#auto-transitions)
- [Simple transitions](#simple-transitions)
- [Integration](#integration)
 - [Podfile](#podfile)
- [Requirements](#requirements)
- [TODO](#todo)
- [P.S.](#ps)

## Auto-transitions

This type of transitions happens when a user makes dragging gesture. If you've specified a view controller (a class or a storyboad ID) for the proper direction, it will appear interactively.

<em>Tip: You can implement this behaviour without any line of code.</em>

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/README%20Graphics/demo_storyboard.gif)

### In code

If you want to do this from code, assign a class of the following view controller to one of the properties:

```
@property (nonatomic) Class leftClass;
@property (nonatomic) Class topClass;
@property (nonatomic) Class rightClass;
@property (nonatomic) Class bottomClass;
```

### Storyboard

You can specify all transitions in storyboard, as well.

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/README%20Graphics/demo_storyboard_inspector.png)

Values are storyboard IDs of view controllers. And keys are determined in CNViewController_Storyboard.h. (Also you can set them in code.)

This approach allows users to move forward by dragging, but all the controllers must be created in the **same** storyboard.

## Simple Transitions

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/README%20Graphics/demo_present.gif)

### In code

``` objc
XXViewController *nextViewController = ...;
[self presentViewController:nextViewController direction:CNDirectionTop animated:YES];
```

If at least two controllers are in the stack, users can drag back to return interactively to the previous screen (like `UINavigationController`). Or you can do the same in code (but obviously without interactivity):

``` objc
[nextViewController dismissViewControllerAnimated:YES completion:^{ ... }];
```

This is UIViewController's method which was overridden.

- Override

``` objc
- (void)viewIsAppearing:(CGFloat)percentComplete { ... }
```

method in CNViewController subclass to be notified what is the current rate of a visible part of the screen. This method fires during transitions (both, interactive and noninteractive).

- Override

``` objc
- (BOOL)shouldAutotransitToDirection:(CNDirection)direction present:(BOOL)present { ... }
```

to take a control over interactive transitions. You may allow them or prohibit depends on your app's logic.
present parameter is YES if a considered transition will lead to an appearance of a new view controller in a stack. If NO, this is a back transition.

### Storyboard

If you use a storyboard, you can easily create a segue between two CNViewController-s. When you drop a connection on a destination view controller, you'll see a popup with a list of available segues. bottom (`CNBottomSegue`), left (`CNLeftSegue`), right (`CNRightSegue`), and top (`CNLeftSegue`) come from CrossNavigation library, but all others are available too. You won't get a crash if you made a common modal transition from CNViewController. But you will, if you made one of those four transitions (bottom, left, right, or top) between view controllers which are not actually objects of `CNViewController`, `CNNavigationController`, or `CNTabBarController` class (or of it's subclasses), it's required for both controllers.

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/README%20Graphics/demo_segue_connecting.png)

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/README%20Graphics/demo_segue_inspector.png)

## Integration

All you need is CrossNavigation directory. Just copy it to your project and import "CNViewController.h" or "CNViewController_Storyboard.h" (if you're going to use storyboard part of the functionality, as well), nothing else.

### Podfile

```
platform :ios, '7.0'
pod "CrossNavigation"
```

## Requirements

- iOS 7.0+
- UIKit framework
- Foundation framework

## TODO

- Support partial screen transitions (like a side screen)
- <s>Port the library to Swift</s> (thanks to [Nicolas Purita](https://github.com/nicopuri))
- <s>Segues support</s>

## P.S.

I'm really interested to know, what do you think about this library. If you have a complaint, a suggestion, or a question, please, send it on my e-mail: artem.stepanenko.1@gmail.com. Thank you.
