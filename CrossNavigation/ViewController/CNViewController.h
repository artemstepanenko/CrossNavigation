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
 Dismisses a view controller that was presented modally by a receiver.
 
 This is UIViewController's method which was overridden in CNViewController. It dismisses the view controller in the opposite direction to the presentation.
 
 You may call this method in case if CNViewController object was presented by a common UIViewController object, as well.
 
 @param animated Determines whether the view controller will be dismissed animated or not
 @param completion The block to execute after the view controller is dismissed. May be nil.
 */
- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

/**
 Dismisses a view controller that was presented modally by a receiver in a defined direction.

 If a receiver is not a last view controller in a stack, it dismisses all subsequent view controllers. So when animation is finished, the receiver becomes a visible view controller. A transition occurs from the visible view controller to the receiver.

 @param direction Determines in what direction view controller will be dismissed
 @param animated Determines whether the view controller will be dismissed animated or not
 @param completion The block to execute after the view controller is dismissed. May be nil.
 */
- (void)dismissViewControllerToDirection:(CNDirection)direction
                                animated:(BOOL)animated
                              completion:(void (^)(void))completion;

/**
 Notifies that it's view is partly presented.
 Fires during transitions.

 @warning don't call this method directly
 
 @param percentComplete The percentage of the currently visible part of the screen
 */
- (void)viewIsAppearing:(CGFloat)percentComplete;

/**
 Returns a Boolean value indicating whether a receiver is allowed to transit to a specified direction.
 Fires when an appropriate gesture is detected and there is a known view controller to be shown for the detected direction.
 
 @warning don't call this method directly
 
 @param direction The direction of a transition under consideration.
 @param present If YES, a new view controller is about to be presented. If NO, the receiver is about to be dismissed.
 
 @return YES if the transition should occur, otherwise NO. Default value is YES.
 */
- (BOOL)shouldAutotransitToDirection:(CNDirection)direction present:(BOOL)present;

/**
 Override this method to control whether you want or not to support interactive transitions from a current view controller.

 A returned value must not be changed.
 
 To make an interactive transition a UIPanGestureRecognizer object is used. If this method returns NO, the gesture recognizer isn't even created.
 
 @return YES to allow interactive navigation from the current view controller to others. Default value is YES.
 */
- (BOOL)supportsInteractiveTransition;

@end
