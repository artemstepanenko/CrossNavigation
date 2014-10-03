//
// CNViewController.h
//
// Copyright (c) 2014 Artem Stepanenko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "cn_direction.h"

/**
 if you inherit your view controllers from CNViewController, you'll be able to push them to the stack not just to right side (as you do if you use UINavigationController), but to any of four: left, top, right, bottom. Supports autorotations.
 
 @see CNViewController_Storyboard.h
 */

@interface CNViewController : UIViewController

/**
 Presents a view controller.
 
 @param viewController The view controller to be presented. Should be an instance of CNViewController or any class inherited from CNViewController.
 @param direction The direction of appearance the next view controller
 @param animated Determines whether view controller will be presented animated or not
 @param completion The block to execute after the presentation finishes. May be nil.
 */
- (void)presentViewController:(CNViewController *)viewController
                    direction:(CNDirection)direction
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion;

/**
 Dismisses the view controller that was presented modally by the receiver.
 
 This is UIViewController's method which was overridden in CNViewController. It dismisses the view controller in the opposite direction to the presentation.
 
 You may call this method in case if CNViewController object was presented by a common UIViewController object, as well.
 
 @param animated Determines whether view controller will be presented animated or not
 @param completion The block to execute after the view controller is dismissed. May be nil.
 */
- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

/**
 Notifies that it's view is partly presented. This method fires during transitions.
 
 @param percentComplete The percentage of the currently visible part of the screen
 
 @warning don't call this method directly
 */
- (void)viewIsAppearing:(CGFloat)percentComplete;

@end
