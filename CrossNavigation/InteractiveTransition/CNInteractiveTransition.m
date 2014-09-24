//
// CNInteractiveTransition.m
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

#import "CNInteractiveTransition.h"
#import "CNViewController.h"
#import "CNTransitioningFactory.h"
#import "CNTransitioning.h"
#import "cn_utils.h"

@interface CNInteractiveTransition ()

@property (nonatomic, weak) CNViewController *fromViewController;
@property (nonatomic, weak) CNViewController *toViewController;

@property (nonatomic, strong) CNTransitioning *appearanceTransitioning;
@property (nonatomic, strong) CNTransitioning *disappearanceTransitioning;

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation CNInteractiveTransition

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _direction = CNDirectionNone;
    }
    
    return self;
}

- (void)setDirection:(CNDirection)direction
{
    _direction = direction;
    
    self.appearanceTransitioning = [CNTransitioningFactory transitioningForDirection:direction present:YES];
    self.disappearanceTransitioning = [CNTransitioningFactory transitioningForDirection:direction present:NO];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return self.appearanceTransitioning;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.disappearanceTransitioning;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    if (self.interactive) {
        return self;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if (self.interactive) {
        return self;
    }
    
    return nil;
}

#pragma mark - Interactive Transitioning

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    self.containerView = [self.transitionContext containerView];
    
    CGRect containerFrame = self.containerView.bounds;
    
    // from view controller
    self.fromViewController = (CNViewController *)[self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.fromViewController.view.frame = [self.appearanceTransitioning fromViewStartFrameWithContainerFrame:containerFrame];
    [self.containerView addSubview:self.fromViewController.view];
    
    // to view controller
    self.toViewController = (CNViewController *)[self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.toViewController.view.frame = [self.appearanceTransitioning toViewStartFrameWithContainerFrame:containerFrame];
    [self.containerView addSubview:self.toViewController.view];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    CGRect containerFrame = self.containerView.bounds;
    
    // normalization
    percentComplete = MAX(0.0f, percentComplete);
    percentComplete = MIN(1.0f, percentComplete);
    
    // update fromViewController's frame
    self.fromViewController.view.frame = CGRectTransform([self.appearanceTransitioning fromViewStartFrameWithContainerFrame:containerFrame],
                                                         [self.appearanceTransitioning fromViewEndFrameWithContainerFrame:containerFrame],
                                                         percentComplete);
    
    // update toViewController's frame
    self.toViewController.view.frame = CGRectTransform([self.appearanceTransitioning toViewStartFrameWithContainerFrame:containerFrame],
                                                       [self.appearanceTransitioning toViewEndFrameWithContainerFrame:containerFrame],
                                                       percentComplete);
    
}

- (void)finishInteractiveTransition
{
    [self finishInteractiveTransition:YES];
}

- (void)cancelInteractiveTransition
{
    [self finishInteractiveTransition:NO];
}

#pragma mark - Private

- (void)finishInteractiveTransition:(BOOL)didComplete
{
    CGRect containerFrame = self.containerView.bounds;
    CGAffineTransform transform = self.containerView.transform;
    
    [UIView animateWithDuration:[CNTransitioning duration] animations:^{
        
        if (didComplete) {
            self.fromViewController.view.frame = [self.appearanceTransitioning fromViewEndFrameWithContainerFrame:containerFrame];
            self.toViewController.view.frame = [self.appearanceTransitioning toViewEndFrameWithContainerFrame:containerFrame];
        } else {
            self.fromViewController.view.frame = [self.appearanceTransitioning fromViewStartFrameWithContainerFrame:containerFrame];
            self.toViewController.view.frame = [self.appearanceTransitioning toViewStartFrameWithContainerFrame:containerFrame];
        }
        
    } completion:^(BOOL finished) {
        
        [self.transitionContext completeTransition:didComplete];
        self.transitionContext = nil;
        self.containerView = nil;
        
        // reason of existence of these lines is Apple's bug
        if (didComplete) {
            self.toViewController.view.transform = transform;
            self.toViewController.view.frame = self.toViewController.view.superview.bounds;
        } else {
            self.fromViewController.view.transform = transform;
            self.fromViewController.view.frame = self.fromViewController.view.superview.bounds;
        }
    }];
}

@end
