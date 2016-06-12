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
#import "UIViewController+CNPrivate.h"
#import "CNTimer.h"
#import <UIKit/UIKit.h>

@interface CNViewControllerCore () <CNPanGestureHandlerDelegate>

@property (nonatomic, weak) CNGenericViewController *viewController;
@property (nonatomic, weak) CNGenericViewController *nextViewController;
@property (nonatomic) CNInteractiveTransition *interactiveTransition;
@property (nonatomic, strong) CNPanGestureHandler *panGestureHandler;
@property (nonatomic, assign) CNDirection direction;

@end

@implementation CNViewControllerCore

- (instancetype)initWithViewController:(CNGenericViewController *)viewController
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

- (void)presentViewController:(CNGenericViewController *)viewController
                    direction:(CNDirection)direction
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion
{
    if ([self isTransitioning]) {
        return;
    }
    
    [self prepareForTransitionToDirection:direction interactive:NO];
    
    [self transitionWillFinishFromViewController:self.viewController
                                          toViewController:viewController
                                     recentPercentComplete:0.0f
                                                  animated:animated];
    
    [self.viewController presentViewController:viewController animated:animated completion:completion];
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

- (void)setLeftClass:(Class)leftClass
{
    if (self.direction == CNDirectionRight) {
        return;
    }
    
    _leftID = nil;
    _leftClass = leftClass;
}

- (void)setTopClass:(Class)topClass
{
    if (self.direction == CNDirectionBottom) {
        return;
    }
    
    _topID = nil;
    _topClass = topClass;
}

- (void)setRightClass:(Class)rightClass
{
    if (self.direction == CNDirectionLeft) {
        return;
    }
    
    _rightID = nil;
    _rightClass = rightClass;
}

- (void)setBottomClass:(Class)bottomClass
{
    if (self.direction == CNDirectionTop) {
        return;
    }
    
    _bottomID = nil;
    _bottomClass = bottomClass;
}

- (void)setLeftID:(NSString *)leftStoryboardID
{
    if (self.direction == CNDirectionRight) {
        return;
    }
    
    _leftClass = nil;
    _leftID = leftStoryboardID;
}

- (void)setTopID:(NSString *)topStoryboardID
{
    if (self.direction == CNDirectionBottom) {
        return;
    }
    
    _topClass = nil;
    _topID = topStoryboardID;
}

- (void)setRightID:(NSString *)rightStoryboardID
{
    if (self.direction == CNDirectionLeft) {
        return;
    }
    
    _rightClass = nil;
    _rightID = rightStoryboardID;
}

- (void)setBottomID:(NSString *)bottomStoryboardID
{
    if (self.direction == CNDirectionTop) {
        return;
    }
    
    _bottomClass = nil;
    _bottomID = bottomStoryboardID;
}

#pragma mark - CNPanGestureHandlerDelegate

- (void)panGestureHandler:(CNPanGestureHandler *)sender didStartForDirection:(CNDirection)direction
{
    __weak typeof(self) weakSelf = self;
    
    if (CNDirectionOppositeToDirection(self.direction, direction)) {
        
        [self prepareForBackTransitionInteractive:YES];
        
        [self.viewController super_dismissViewControllerAnimated:YES completion:^{       // FIXME: self.viewController.super
            weakSelf.nextViewController = nil;
        }];
        
    } else {
        
        self.nextViewController = [self createNextViewControllerForDirection:direction];
        [self.nextViewController.core prepareForTransitionToDirection:direction interactive:YES];
        
        [self.viewController presentViewController:self.nextViewController animated:YES completion:^{
            weakSelf.nextViewController = nil;
        }];
    }
}

- (void)panGestureHandler:(CNPanGestureHandler *)sender didUpdateWithRatio:(CGFloat)ratio
{
    if (!self.nextViewController.core.interactiveTransition.containerView) {
        return;
    }
    
    [self.nextViewController.core.interactiveTransition updateInteractiveTransition:ratio];
    
    // send events
    CGFloat percentComplete = self.nextViewController.core.interactiveTransition.recentPercentComplete;
    [self.nextViewController.core.interactiveTransition.toViewController viewIsAppearing:percentComplete];
    [self.nextViewController.core.interactiveTransition.fromViewController viewIsAppearing:(1.0f - percentComplete)];
}

- (void)panGestureHandlerDidFinish:(CNPanGestureHandler *)sender
{
    [self.nextViewController.core.interactiveTransition finishInteractiveTransition];
    
    [self.nextViewController.core transitionWillFinishFromViewController:self.nextViewController.core.interactiveTransition.fromViewController
                                                   toViewController:self.nextViewController.core.interactiveTransition.toViewController
                                              recentPercentComplete:self.nextViewController.core.interactiveTransition.recentPercentComplete
                                                           animated:YES];
}

- (void)panGestureHandlerDidCancel:(CNPanGestureHandler *)sender
{
    [self.nextViewController.core.interactiveTransition cancelInteractiveTransition];
    
    [self.nextViewController.core transitionWillFinishFromViewController:self.nextViewController.core.interactiveTransition.toViewController
                                                   toViewController:self.nextViewController.core.interactiveTransition.fromViewController
                                              recentPercentComplete:(1.0f - self.nextViewController.core.interactiveTransition.recentPercentComplete)
                                                           animated:YES];
}

- (CNDirection)panGestureHandler:(CNPanGestureHandler *)sender directionForOffset:(CGPoint)offset
{
    if ([self isTransitioning]) {
        return CNDirectionNone;
    }
    
    CNDirection direction = CNDirectionNone;
    CNDirection backDirection = CNDirectionGetOpposite(self.direction);
    
    if (fabs(offset.x) >= fabs(offset.y)) {
        
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
        return [self.viewController shouldAutotransitToDirection:direction present:!(direction == backDirection)] ? direction : CNDirectionNone;
    }
    
    return CNDirectionNone;
}

- (CGPoint)panGestureHandler:(CNPanGestureHandler *)sender locationOfGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *view = self.nextViewController.core.interactiveTransition.containerView;
    view = (view ? view : self.viewController.view);
    
    return [gestureRecognizer locationInView:view];
}

- (CGSize)viewSizeForPanGestureHandler:(CNPanGestureHandler *)sender
{
    UIView *view = self.nextViewController.core.interactiveTransition.containerView;
    view = (view ? view : self.viewController.view);
    
    return view.bounds.size;
}

- (void)viewDidLoad
{
    if ([self.viewController supportsInteractiveTransition]) {
        [self initializePanGestureRecognizer];
    }
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
    CNGenericViewController *visibleViewController = (CNGenericViewController *)[self visibleViewController];
    
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
    UIViewController *toViewController = self.viewController.presentingViewController;
    
    // FIXME: polish a case when toViewController is not CNViewController
    // FIXME: fix for the case when animation is NO
    if ([toViewController conformsToProtocol:@protocol(CNViewControllerProtocol)]) {
        
        if (animated == YES) {
            [self prepareForBackTransitionInteractive:NO direction:direction];
        }
        
        [self transitionWillFinishFromViewController:self.viewController
                                    toViewController:(CNGenericViewController *)toViewController
                               recentPercentComplete:0.0f
                                            animated:animated];
    }
    
    [self.viewController super_dismissViewControllerAnimated:animated completion:completion];   // FIXME: viewController.super must be calling this
}

- (void)prepareForBackTransitionInteractive:(BOOL)interactive
{
    [self prepareForBackTransitionInteractive:interactive direction:CNDirectionGetOpposite(self.direction)];
}

- (void)prepareForBackTransitionInteractive:(BOOL)interactive direction:(CNDirection)direction
{
    self.nextViewController = self.viewController;
    self.interactiveTransition.interactive = interactive;
    
    // clears previous direction left from cancelled interaction transition
    if (interactive) {
        self.interactiveTransition.direction = direction;
    } else {
        self.interactiveTransition.direction = CNDirectionGetOpposite(direction);
    }
}

- (CNGenericViewController *)createNextViewControllerForDirection:(CNDirection)direction
{
    Class viewControllerClass = [self classForDirection:direction];
    
    if (viewControllerClass) {
        return [[viewControllerClass alloc] init];
    } else {
        
        NSString *storyboardID = [self storyboardIDForDirection:direction];
        
        if (storyboardID) {
            return [self.viewController.storyboard instantiateViewControllerWithIdentifier:storyboardID];
        }
    }
    
    return nil;
}

- (void)prepareForTransitionToDirection:(CNDirection)direction interactive:(BOOL)interactive
{
    self.viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    self.direction = direction;
    self.interactiveTransition.direction = direction;
    self.interactiveTransition.interactive = interactive;
}

- (void)transitionWillFinishFromViewController:(CNGenericViewController *)fromViewController
                              toViewController:(CNGenericViewController *)toViewController
                         recentPercentComplete:(CGFloat)recentPercentComplete
                                      animated:(BOOL)animated
{
    if (!animated) {
        
        [fromViewController viewIsAppearing:0.0f];
        [toViewController viewIsAppearing:1.0f];
        return;
    }
    
    CNTimer *timer = [[CNTimer alloc] init];
    
    NSTimeInterval timeInterval = 0.04f;    // more than 24 frames per second
    NSUInteger repeatsCount = [self.interactiveTransition finishingDuration] / timeInterval;
    CGFloat portion = (1.0f - recentPercentComplete) / repeatsCount;
    
    [timer startWithTimeInterval:timeInterval repeatsCount:repeatsCount tickCallback:^(NSUInteger index) {
        
        CGFloat percentComplete = recentPercentComplete + portion * index;
        
        [fromViewController viewIsAppearing:(1 - percentComplete)];
        [toViewController viewIsAppearing:percentComplete];
        
    } stopCallback:^(BOOL cancelled) {
        
        [fromViewController viewIsAppearing:0.0f];
        [toViewController viewIsAppearing:1.0f];
        
    }];
}

- (void)initializePanGestureRecognizer
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.panGestureHandler action:@selector(userDidPan:)];
    [self.viewController.view addGestureRecognizer:recognizer];
}

- (UIView *)freezeUI
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageWithView:window]];
    imageView.frame = window.bounds;
    [window addSubview:imageView];
    return imageView;
}

- (UIViewController *)visibleViewController
{
    UIViewController *viewController = self.viewController;
    
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    
    return viewController;
}

- (NSString *)storyboardIDForDirection:(CNDirection)direction
{
    switch (direction) {
        case CNDirectionRight: {
            return self.rightID;
        }
            
        case CNDirectionBottom: {
            return self.bottomID;
        }
            
        case CNDirectionLeft: {
            return self.leftID;
        }
            
        case CNDirectionTop: {
            return self.topID;
        }
            
        default: {
            NSAssert(NO, @"Wrong direction");
            return nil;
        }
    }
}

- (Class)classForDirection:(CNDirection)direction
{
    switch (direction) {
        case CNDirectionRight: {
            return self.rightClass;
        }
            
        case CNDirectionBottom: {
            return self.bottomClass;
        }
            
        case CNDirectionLeft: {
            return self.leftClass;
        }
            
        case CNDirectionTop: {
            return self.topClass;
        }
            
        default: {
            NSAssert(NO, @"Wrong direction");
            return nil;
        }
    }
}

- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark Autotransition

- (BOOL)supportsAutotransitionToDirection:(CNDirection)direction
{
    switch (direction) {
        case CNDirectionRight: {
            return self.rightClass || self.rightID;
        }
            
        case CNDirectionBottom: {
            return self.bottomClass || self.bottomID;
        }
            
        case CNDirectionLeft: {
            return self.leftClass || self.leftID;
        }
            
        case CNDirectionTop: {
            return self.topClass || self.topID;
        }
            
        default: {
            return NO;
        }
    }
}

@end
