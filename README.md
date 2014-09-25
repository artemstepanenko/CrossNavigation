# CrossNavigation

if you inherit your view controllers from CNViewController, you'll be able to push them to the stack not just to right side (as you do if you use UINavigationController), but to any of four: left, top, right, bottom. Supports autorotations.

## Usage

### You can make a transition in code

``` objc
XXViewController *nextViewController = ...;
[self presentViewController:nextViewController direction:CNDirectionTop animated:YES];
```

If at least two controllers are in the stack, users can drag back to return interactively to the previous screen (like UINavigationController).

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/demo_present.gif)

### Storyboard

You can specify all transitions in storyboard, as well.

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/demo_storyboard_inspector.png)

Values are storyboard IDs of view controllers. And keys are determined in CNViewController_Storyboard.h. (Also you can set them in code.)

This approach allows users to move forward by dragging, but all the controllers must be created in the **same** storyboard.

### Restrictions

- The only one class that should be used directly is CNViewController.
- The view controllers must be initialized with a xib-file or by a storyboard object.

## Demo

![](https://github.com/artemstepanenko/CrossNavigation/blob/master/demo_storyboard.gif)

## Integration

All you need is CrossNavigation directory. Just copy it to your project.
(CocoaPod is comming soon...)

## Requirements

- iOS 7.0+
- UIKit framework
- Foundation framework
