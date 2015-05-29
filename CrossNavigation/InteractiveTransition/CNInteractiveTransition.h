//
// CNInteractiveTransition.h
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

#import <UIKit/UIKit.h>
#import "cn_direction.h"

@class CNViewController;

@interface CNInteractiveTransition : UIPercentDrivenInteractiveTransition <UIViewControllerTransitioningDelegate>

@property (nonatomic, weak, readonly) CNViewController *fromViewController;
@property (nonatomic, weak, readonly) CNViewController *toViewController;
@property (nonatomic, strong, readonly) UIView *containerView;

@property (nonatomic, assign, readonly) CGFloat finishingDuration;  // duration (in seconds) which takes simple transition (presenting/dismissing) and finishing non interactive transition
@property (nonatomic, assign, readonly) CGFloat recentPercentComplete;  // contains recent value for interactive animation

@property (nonatomic, assign) CNDirection direction;
@property (nonatomic, assign) BOOL interactive;

- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)finishInteractiveTransition;
- (void)cancelInteractiveTransition;

@end
