//
//  CNViewControllerCore.m
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 5/19/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import "CNViewControllerCore.h"
#import "CNViewControllerProtocol.h"
#import "CNInteractiveTransition.h"
#import "CNPanGestureHandler.h"
#import <UIKit/UIKit.h>

@interface CNViewControllerCore () <CNPanGestureHandlerDelegate>

@property (nonatomic, weak) UIViewController<CNViewControllerProtocol> *viewController;
@property (nonatomic, weak) UIViewController<CNViewControllerProtocol> *nextViewController;
@property (nonatomic) CNInteractiveTransition *interactiveTransition;
@property (nonatomic, strong) CNPanGestureHandler *panGestureHandler;
@property (nonatomic, assign) CNDirection direction;

@end

@implementation CNViewControllerCore

- (instancetype)initWithViewController:(UIViewController<CNViewControllerProtocol> *)viewController
{
    self = [super init];
    
    if (self) {
        
        _viewController = viewController;
        
        _interactiveTransition = [CNInteractiveTransition new];
        _viewController.transitioningDelegate = _interactiveTransition;
        _direction = CNDirectionNone;
        
        if ([_viewController supportsInteractiveTransition]) {
            _panGestureHandler = [[CNPanGestureHandler alloc] initWithDelegate:self];
        }
    }
    
    return self;
}

- (void)dismissViewControllerAnimated:(BOOL)animated
                           completion:(void (^)(void))completion
{
    [self dismissViewControllerToDirection:CNDirectionGetOpposite(self.direction)
                                  animated:animated
                                completion:completion];
}

- (void)dismissViewControllerToDirection:(CNDirection)direction
                                animated:(BOOL)animated
                              completion:(void (^)(void))completion
{
    if ([self isTransitioning]) {
        return;
    }
    
    if (self.viewController.presentedViewController.presentedViewController) {
        // rather tricky case since default behaviour is buggy
        [self dismissInvisibleViewControllerToDirection:direction animated:animated completion:completion];
    } else {
        [self dismissVisibleViewControllerToDirection:direction animated:animated completion:completion];
    }
}

#pragma mark - CNPanGestureHandlerDelegate

- (void)panGestureHandler:(CNPanGestureHandler *)sender didStartForDirection:(CNDirection)direction
{
    __weak typeof(self) weakSelf = self;
    
    if (CNDirectionOppositeToDirection(self.direction, direction)) {
        
        [self prepareForBackTransitionInteractive:YES];
        
        [self dismissViewControllerAnimated:YES completion:^{       // FIXME: self.viewController.super
            weakSelf.nextViewController = nil;
        }];
        
    } else {
        
        self.nextViewController = [self createNextViewControllerForDirection:direction];
        [self.nextViewController prepareForTransitionToDirection:direction interactive:YES];
        
        [self presentViewController:self.nextViewController animated:YES completion:^{
            weakSelf.nextViewController = nil;
        }];
    }
}

- (void)panGestureHandler:(CNPanGestureHandler *)sender didUpdateWithRatio:(CGFloat)ratio
{
    if (!self.nextViewController.interactiveTransition.containerView) {
        return;
    }
    
    [self.nextViewController.interactiveTransition updateInteractiveTransition:ratio];
    
    // send events
    CGFloat percentComplete = self.nextViewController.interactiveTransition.recentPercentComplete;
    [self.nextViewController.interactiveTransition.toViewController viewIsAppearing:percentComplete];
    [self.nextViewController.interactiveTransition.fromViewController viewIsAppearing:(1.0f - percentComplete)];
}

- (void)panGestureHandlerDidFinish:(CNPanGestureHandler *)sender
{
    [self.nextViewController.interactiveTransition finishInteractiveTransition];
    
    [self.nextViewController transitionWillFinishFromViewController:self.nextViewController.interactiveTransition.fromViewController
                                                   toViewController:self.nextViewController.interactiveTransition.toViewController
                                              recentPercentComplete:self.nextViewController.interactiveTransition.recentPercentComplete
                                                           animated:YES];
}

- (void)panGestureHandlerDidCancel:(CNPanGestureHandler *)sender
{
    [self.nextViewController.interactiveTransition cancelInteractiveTransition];
    
    [self.nextViewController transitionWillFinishFromViewController:self.nextViewController.interactiveTransition.toViewController
                                                   toViewController:self.nextViewController.interactiveTransition.fromViewController
                                              recentPercentComplete:(1.0f - self.nextViewController.interactiveTransition.recentPercentComplete)
                                                           animated:YES];
}

- (CNDirection)panGestureHandler:(CNPanGestureHandler *)sender directionForOffset:(CGPoint)offset
{
    if ([self isTransitioning]) {
        return CNDirectionNone;
    }
    
    CNDirection direction = CNDirectionNone;
    CNDirection backDirection = CNDirectionGetOpposite(self.direction);
    
    if (fabsf(offset.x) >= fabsf(offset.y)) {
        
        if (offset.x < 0) {
            
            if ((backDirection == CNDirectionRight) || [self supportsAutotransitionToDirection:CNDirectionRight]) {
                direction = CNDirectionRight;
            } else {
                direction = CNDirectionNone;
            }
        } else {
            if ((backDirection == CNDirectionLeft) || [self supportsAutotransitionToDirection:CNDirectionLeft]) {
                direction = CNDirectionLeft;
            } else {
                direction = CNDirectionNone;
            }
        }
    } else {
        
        if (offset.y < 0) {
            if ((backDirection == CNDirectionBottom) || [self supportsAutotransitionToDirection:CNDirectionBottom]) {
                direction = CNDirectionBottom;
            } else {
                direction = CNDirectionNone;
            }
        } else {
            if ((backDirection == CNDirectionTop) || [self supportsAutotransitionToDirection:CNDirectionTop]) {
                direction = CNDirectionTop;
            } else {
                direction = CNDirectionNone;
            }
        }
    }
    
    if (direction != CNDirectionNone) {
        return [self shouldAutotransitToDirection:direction present:!(direction == backDirection)] ? direction : CNDirectionNone;
    }
    
    return CNDirectionNone;
}

- (CGPoint)panGestureHandler:(CNPanGestureHandler *)sender locationOfGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *view = self.nextViewController.interactiveTransition.containerView;
    view = (view ? view : self.view);
    
    return [gestureRecognizer locationInView:view];
}

- (CGSize)viewSizeForPanGestureHandler:(CNPanGestureHandler *)sender
{
    UIView *view = self.nextViewController.interactiveTransition.containerView;
    view = (view ? view : self.view);
    
    return view.bounds.size;
}

#pragma mark - Private

- (BOOL)isTransitioning
{
    return [self.viewController isBeingPresented] || [self.viewController isBeingDismissed];
}

// this method is quite tricky
//
- (void)dismissInvisibleViewControllerToDirection:(CNDirection)direction
                                         animated:(BOOL)animated
                                       completion:(void (^)(void))completion
{
    // - Now let's do some magic!
    
    // a visible view controller
    CNViewController *visibleViewController = (CNViewController *)[self visibleViewController];
    
    // freeze UI (we need this to avoid a blinking during further operations)
    UIView *frozenView = [self freezeUI];
    
    // dismiss all subsequent view controllers in a stack
    [self dismissVisibleViewControllerToDirection:CNDirectionNone animated:NO completion:^{
        
        // present a previously visible view controller
        [self presentViewController:visibleViewController direction:CNDirectionGetOpposite(direction) animated:NO completion:^{
            
            // at this point a receiver is followed by the visible view controller (all intermediate view controllers are removed, if had existed)
            
            // unfreeze UI
            [frozenView removeFromSuperview];
            
            // dismiss params
            NSDictionary *dismissParams = [UIViewController createParamsForDismissAnimated:animated completion:completion];
            
            // make a common dismiss
            [visibleViewController performSelector:@selector(dismissWithParams:) withObject:dismissParams afterDelay:0.0f];
        }];
    }];
}

- (void)dismissVisibleViewControllerToDirection:(CNDirection)direction
                                       animated:(BOOL)animated
                                     completion:(void (^)(void))completion
{
    UIViewController *toViewController = self.presentingViewController;
    
    // FIXME: polish a case when toViewController is not CNViewController
    // FIXME: fix for the case when animation is NO
    if ([toViewController isKindOfClass:[CNViewController class]]) {
        
        if (animated == YES) {
            [self prepareForBackTransitionInteractive:NO direction:direction];
        }
        
        [self transitionWillFinishFromViewController:self
                                    toViewController:(CNViewController *)toViewController
                               recentPercentComplete:0.0f
                                            animated:animated];
    }
    
    [super dismissViewControllerAnimated:animated completion:completion];
}

- (void)prepareForBackTransitionInteractive:(BOOL)interactive
{
    [self prepareForBackTransitionInteractive:interactive direction:CNDirectionGetOpposite(self.direction)];
}

- (UIViewController<CNViewControllerProtocol>)createNextViewControllerForDirection:(CNDirection)direction
{
    Class viewControllerClass = [self classForDirection:direction];
    
    if (viewControllerClass) {
        return [[viewControllerClass alloc] init];
    } else {
        
        NSString *storyboardID = [self storyboardIDForDirection:direction];
        
        if (storyboardID) {
            return [self.storyboard instantiateViewControllerWithIdentifier:storyboardID];
        }
    }
    
    return nil;
}

@end
