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
    [viewController transitionWillFinishFromViewController:self toViewController:viewController recentPercentComplete:0.0f];
    [self presentViewController:viewController animated:animated completion:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if ([self isTransitioning]) {
        return;
    }
    
    UIViewController *previousViewController = self.presentingViewController;
    
    if ([previousViewController isKindOfClass:[CNViewController class]]) {
        [self prepareForBackTransitionInteractive:NO];
        [self transitionWillFinishFromViewController:self toViewController:(CNViewController *)previousViewController recentPercentComplete:0.0f];
    }
    
    [super dismissViewControllerAnimated:animated completion:completion];
}

#pragma mark - Appearance

- (void)viewIsAppearing:(CGFloat)percentComplete
{
    // default implementation does nothing
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

#pragma mark - Private

- (void)initialize
{
    self.interactiveTransition = [CNInteractiveTransition new];
    self.transitioningDelegate = self.interactiveTransition;
    self.direction = CNDirectionNone;
    
    self.panGestureHandler = [[CNPanGestureHandler alloc] initWithDelegate:self];
}

- (void)transitionWillFinishFromViewController:(CNViewController *)fromViewController
                              toViewController:(CNViewController *)toViewController
                         recentPercentComplete:(CGFloat)recentPercentComplete
{
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
                                              recentPercentComplete:self.nextViewController.interactiveTransition.recentPercentComplete];
}

- (void)panGestureHandlerDidCancel:(CNPanGestureHandler *)sender
{
    [self.nextViewController.interactiveTransition cancelInteractiveTransition];
    
    [self.nextViewController transitionWillFinishFromViewController:self.nextViewController.interactiveTransition.toViewController
                                                   toViewController:self.nextViewController.interactiveTransition.fromViewController
                                              recentPercentComplete:(1.0f - self.nextViewController.interactiveTransition.recentPercentComplete)];
}

- (CNDirection)panGestureHandler:(CNPanGestureHandler *)sender directionForOffset:(CGPoint)offset
{
    if ([self isTransitioning]) {
        return CNDirectionNone;
    }
    
    CNDirection backDirection = CNDirectionGetOpposite(self.direction);
    
    if (fabsf(offset.x) >= fabsf(offset.y)) {
        
        if (offset.x < 0) {
            
            if ((backDirection == CNDirectionRight) || self.rightID) {
                return CNDirectionRight;
            } else {
                return CNDirectionNone;
            }
        } else {
            if ((backDirection == CNDirectionLeft) || self.leftID) {
                return CNDirectionLeft;
            } else {
                return CNDirectionNone;
            }
        }
    } else {
        
        if (offset.y < 0) {
            if ((backDirection == CNDirectionBottom) || self.bottomID) {
                return CNDirectionBottom;
            } else {
                return CNDirectionNone;
            }
        } else {
            if ((backDirection == CNDirectionTop) || self.topID) {
                return CNDirectionTop;
            } else {
                return CNDirectionNone;
            }
        }
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

- (void)initializePanGestureRecognizer
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.panGestureHandler action:@selector(userDidPan:)];
    [self.view addGestureRecognizer:recognizer];
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
    self.nextViewController = self;
    self.interactiveTransition.interactive = interactive;
    
    // clears previous direction left from cancelled interaction transition
    if (interactive) {
        self.interactiveTransition.direction = CNDirectionGetOpposite(self.direction);
    } else {
        self.interactiveTransition.direction = self.direction;
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

@end
