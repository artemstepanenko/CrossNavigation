//
//  CNViewControllerProtocol.h
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 17/05/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cn_direction.h"
#import "CNGenericViewController.h"

@class CNViewControllerCore;

@protocol CNViewControllerProtocol <NSObject>

/**
 Presents a view controller.
 
 @param viewController The view controller to be presented. Should be an instance of CNViewController or any class inherited from CNViewController.
 @param direction The direction of appearance the next view controller
 @param animated Determines whether view controller will be presented animated or not
 @param completion The block to execute after the presentation finishes. May be nil.
 */
- (void)presentViewController:(CNGenericViewController *)viewController
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


/**
 Use methods/properties from this interface to implement auto-transitions.
 It means that following view controllers are presented automatically when a user makes a proper dragging gesture.
 */

#pragma mark Storyboard

/**
 Properties for storybord's identifiers of following view controllers. One - for each direction.
 If appropriate view controller is set, user can make an interactive transition by dragging.
 
 @warning storyboard identifiers must belong to instances of CNViewController or any other classes inherited from CNViewController
 @warning view controllers must be in the same storyboard
 */

/**
 Specifies the following left view controller's storyboard identifier.
 */
@property (nonatomic) IBInspectable NSString *leftID;

/**
 Specifies the following top view controller's storyboard identifier.
 */
@property (nonatomic) IBInspectable NSString *topID;

/**
 Specifies the following right view controller's storyboard identifier.
 */
@property (nonatomic) IBInspectable NSString *rightID;

/**
 Specifies the following bottom view controller's storyboard identifier.
 */
@property (nonatomic) IBInspectable NSString *bottomID;

#pragma mark In Code

/**
 Properties for classes of following view controllers.
 Actual instances are created using the most simple initializer:
 
 CNViewController *cnViewController = [[cnClass new] init];
 
 @warning provided classes must be CNViewController or any other classes inherited from CNViewController
 */

/**
 Specifies the following left view controller's class.
 */
@property (nonatomic, strong) Class leftClass;

/**
 Specifies the following top view controller's class.
 */
@property (nonatomic, strong) Class topClass;

/**
 Specifies the following right view controller's class.
 */
@property (nonatomic, strong) Class rightClass;

/**
 Specifies the following bottom view controller's class.
 */
@property (nonatomic, strong) Class bottomClass;

@end
