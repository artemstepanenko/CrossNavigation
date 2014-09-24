//
// CNTransitioning.m
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

#import "CNTransitioning.h"
#import "cn_utils.h"

@implementation CNTransitioning

+ (CGFloat)duration
{
    return 0.3f;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return [[self class] duration];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // container
    UIView *containerView = transitionContext.containerView;
    CGRect containerBounds = containerView.bounds;
    
    // from
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    fromView.frame = [self fromViewStartFrameWithContainerFrame:containerBounds];
    
    // to
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    toView.frame = [self toViewStartFrameWithContainerFrame:containerBounds];
    [containerView addSubview:toView];
    
    // transiotion
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromView.frame = [self fromViewEndFrameWithContainerFrame:containerBounds];
        toView.frame = [self toViewEndFrameWithContainerFrame:containerBounds];
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - Protected

- (CGRect)fromViewStartFrameWithContainerFrame:(CGRect)containerFrame
{
    NSAssert(NO, @"fromViewStartFrameWithContainerFrame: must be overridden");
    return CGRectZero;
}

- (CGRect)toViewStartFrameWithContainerFrame:(CGRect)containerFrame
{
    NSAssert(NO, @"toViewStartFrameWithContainerFrame: must be overridden");
    return CGRectZero;
}

- (CGRect)fromViewEndFrameWithContainerFrame:(CGRect)containerFrame
{
    NSAssert(NO, @"fromViewEndFrameWithContainerFrame: must be overridden");
    return CGRectZero;
}

- (CGRect)toViewEndFrameWithContainerFrame:(CGRect)containerFrame
{
    NSAssert(NO, @"toViewEndFrameWithContainerFrame: must be overridden");
    return CGRectZero;
}

@end
