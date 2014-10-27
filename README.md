# CrossNavigation

if you inherit your view controllers from CNViewController, you'll be able to push them to the stack not just to right side (as you do if you use UINavigationController), but to any of four: left, top, right, bottom. Supports autorotations.

- [Usage](#usage)
 - [You can make a transition in code](#you-can-make-a-transition-in-code)
 - [Storyboard](#storyboard)
 - [Segues](#segues)
 - [Restrictions](#restrictions)
- [Demo](#demo)
- [Integration](#integration)
 - [Podfile](#podfile)
- [Requirements](#requirements)
- [TODO](#todo)
- [P.S.](#ps)

## Usage

### You can make a transition in code

``` objc
XXViewController *nextViewController = ...;
[self presentViewController:nextViewController direction:CNDirectionTop animated:YES];
```

If at least two controllers are in the stack, users can drag back to return interactively to the previous screen (like UINavigationController). Or you can do the same in code (but obviously without interactivity):

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

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/README%20Graphics/demo_present.gif)

### Storyboard

You can specify all transitions in storyboard, as well.

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/README%20Graphics/demo_storyboard_inspector.png)

Values are storyboard IDs of view controllers. And keys are determined in CNViewController_Storyboard.h. (Also you can set them in code.)

This approach allows users to move forward by dragging, but all the controllers must be created in the **same** storyboard.

### Segues

If you use a storyboard, you can easily create a segue between two CNViewController-s. When you drop a connection on a destination view controller, you'll see a popup with a list of available segues. bottom (CNBottomSegue), left (CNLeftSegue), right (CNRightSegue), and top (CNLeftSegue) come from CrossNavigation library, but all others are available too. You won't get a crash if you made a common modal transition from CNViewController. But you will, if you made one of those four transitions (bottom, left, right, or top) between view controllers which are not actually objects of CNViewController class (or of it's subclasses), it's required for both controllers.

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/README%20Graphics/demo_segue_connecting.png)

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/README%20Graphics/demo_segue_inspector.png)


### Restrictions

- The only one class that should be used directly is CNViewController.
- The view controllers must be initialized with a xib-file or by a storyboard object.

## Demo

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/README%20Graphics/demo_storyboard.gif)

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

- Port the library to Swift
- Support partial screen transitions (like a side screen)
- <s>Segues support</s>

## P.S.

I'm really interested to know, what do you think about this library. If you have a complaint, a suggestion, or a question, please, send it on my e-mail: artem.stepanenko.1@gmail.com. Thank you.
