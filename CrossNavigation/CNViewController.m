//
// CNViewController.m
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

#import "CNViewController_Storyboard.h"
#import "CNTransitioningFactory.h"
#import "CNInteractiveTransition.h"
#import "CNPanGestureHandler.h"
#import "CNTimer.h"
#import <QuartzCore/QuartzCore.h>

@interface CNViewController () <CNPanGestureHandlerDelegate>

@property (nonatomic, weak) CNViewController *nextViewController;
@property (nonatomic, strong) CNInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) CNDirection direction;
@property (nonatomic, strong) CNPanGestureHandler *panGestureHandler;

@end

@implementation CNViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializePanGestureRecognizer];
}

- (void)presentViewController:(CNViewController *)viewController
                    direction:(CNDirection)direction
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion
{
    if ([self isTransitioning]) {
        return;
    }
    
    [viewController prepareForTransitionToDirection:direction interactive:NO];
    
    [viewController transitionWillFinishFromViewController:self
                                          toViewController:viewController
                                     recentPercentComplete:0.0f
                                                  animated:animated];
    
    [self presentViewController:viewController animated:animated completion:completion];
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
    
    if (self.presentedViewController) {
        // rather tricky case since default behaviour is buggy
        [self dismissInvisibleViewControllerToDirection:direction animated:animated completion:completion];
    } else {
        [self dismissVisibleViewControllerToDirection:direction animated:animated completion:completion];
    }
}

#pragma mark - Event

- (void)viewIsAppearing:(CGFloat)percentComplete
{
    // default implementation does nothing
}

- (BOOL)shouldAutotransitToDirection:(CNDirection)direction present:(BOOL)present
{
    return YES;
}

#pragma mark - Storyboard

- (void)setLeftID:(NSString *)leftStoryboardID
{
    if (self.direction == CNDirectionRight) {
        return;
    }
    
    _leftID = leftStoryboardID;
}

- (void)setTopID:(NSString *)topStoryboardID
{
    if (self.direction == CNDirectionBottom) {
        return;
    }
    
    _topID = topStoryboardID;
}

- (void)setRightID:(NSString *)rightStoryboardID
{
    if (self.direction == CNDirectionLeft) {
        return;
    }
    
    _rightID = rightStoryboardID;
}

- (void)setBottomID:(NSString *)bottomStoryboardID
{
    if (self.direction == CNDirectionTop) {
        return;
    }
    
    _bottomID = bottomStoryboardID;
}

#pragma mark - CNPanGestureHandlerDelegate

- (void)panGestureHandler:(CNPanGestureHandler *)sender didStartForDirection:(CNDirection)direction
{
    __weak typeof(self) weakSelf = self;
    
    if (CNDirectionOppositeToDirection(self.direction, direction)) {
        
        [self prepareForBackTransitionInteractive:YES];
        
        [super dismissViewControllerAnimated:YES completion:^{
            weakSelf.nextViewController = nil;
        }];
        
    } else {

        NSString *storyboardID = [self storyboardIDForPanDirection:direction];
        self.nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardID];
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
            
            if ((backDirection == CNDirectionRight) || self.rightID) {
                direction = CNDirectionRight;
            } else {
                direction = CNDirectionNone;
            }
        } else {
            if ((backDirection == CNDirectionLeft) || self.leftID) {
                direction = CNDirectionLeft;
            } else {
                direction = CNDirectionNone;
            }
        }
    } else {
        
        if (offset.y < 0) {
            if ((backDirection == CNDirectionBottom) || self.bottomID) {
                direction = CNDirectionBottom;
            } else {
                direction = CNDirectionNone;
            }
        } else {
            if ((backDirection == CNDirectionTop) || self.topID) {
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

- (void)initialize
{
    self.interactiveTransition = [CNInteractiveTransition new];
    self.transitioningDelegate = self.interactiveTransition;
    self.direction = CNDirectionNone;
    
    self.panGestureHandler = [[CNPanGestureHandler alloc] initWithDelegate:self];
}

- (void)initializePanGestureRecognizer
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.panGestureHandler action:@selector(userDidPan:)];
    [self.view addGestureRecognizer:recognizer];
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
            
            [self transitionWillFinishFromViewController:self
                                        toViewController:(CNViewController *)toViewController
                                   recentPercentComplete:0.0f
                                                animated:animated];
        }
    }
    
    [super dismissViewControllerAnimated:animated completion:completion];
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
            NSDictionary *dismissParams = [self createParamsForDismissAnimated:animated completion:completion];
            
            // make a common dismiss
            [visibleViewController performSelector:@selector(dismissWithParams:) withObject:dismissParams afterDelay:0.0f];
        }];
    }];
}

- (UIView *)freezeUI
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageWithView:window]];
    imageView.frame = window.bounds;
    [window addSubview:imageView];
    return imageView;
}

- (void)dismissWithParams:(NSDictionary *)params
{
    [self dismissViewControllerAnimated:[params[@"animated"] boolValue] completion:params[@"completion"]];
}

- (NSDictionary *)createParamsForDismissAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    // params
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"animated"] = @(animated);
    
    if (completion) {
        params[@"completion"] = completion;
    }
    
    return params;
}

- (UIViewController *)visibleViewController
{
    UIViewController *viewController = self;
    
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    
    return viewController;
}

- (void)transitionWillFinishFromViewController:(CNViewController *)fromViewController
                              toViewController:(CNViewController *)toViewController
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

- (BOOL)isTransitioning
{
    return [self isBeingPresented] || [self isBeingDismissed];
}

- (void)prepareForTransitionToDirection:(CNDirection)direction interactive:(BOOL)interactive
{
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.direction = direction;
    self.interactiveTransition.direction = direction;
    self.interactiveTransition.interactive = interactive;
}

- (void)prepareForBackTransitionInteractive:(BOOL)interactive
{
    [self prepareForBackTransitionInteractive:interactive direction:CNDirectionGetOpposite(self.direction)];
}

- (void)prepareForBackTransitionInteractive:(BOOL)interactive direction:(CNDirection)direction
{
    self.nextViewController = self;
    self.interactiveTransition.interactive = interactive;
    
    // clears previous direction left from cancelled interaction transition
    if (interactive) {
        self.interactiveTransition.direction = direction;
    } else {
        self.interactiveTransition.direction = CNDirectionGetOpposite(direction);
    }
}

- (NSString *)storyboardIDForPanDirection:(CNDirection)direction
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

- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
