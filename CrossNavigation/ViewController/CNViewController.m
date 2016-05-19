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

#import "CNViewController.h"
#import "CNTransitioningFactory.h"
#import "CNTimer.h"
#import "CNViewControllerCore.h"
#import "UIViewController+CNPrivate.h"
#import <QuartzCore/QuartzCore.h>

@interface CNViewController ()

@property (nonatomic, strong) CNViewControllerCore *core;

@end

@implementation CNViewController

@synthesize leftClass = _leftClass;
@synthesize rightClass = _rightClass;
@synthesize topClass = _topClass;
@synthesize bottomClass = _bottomClass;
@synthesize leftID = _leftID;
@synthesize rightID = _rightID;
@synthesize topID = _topID;
@synthesize bottomID = _bottomID;

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
    
    if ([self supportsInteractiveTransition]) {
        [self initializePanGestureRecognizer];
    }
}

- (void)presentViewController:(CNViewController *)viewController
                    direction:(CNDirection)direction
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion
{
    if ([self isTransitioning]) {
        return;
    }
    
    if ([viewController isKindOfClass:[CNViewController class]]) {
        [viewController prepareForTransitionToDirection:direction interactive:NO];
        
        [viewController transitionWillFinishFromViewController:self
                                              toViewController:viewController
                                         recentPercentComplete:0.0f
                                                      animated:animated];
    }
    
    [self presentViewController:viewController animated:animated completion:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)animated
                           completion:(void (^)(void))completion
{
    [self.core dismissViewControllerAnimated:animated completion:completion];
}

- (void)dismissViewControllerToDirection:(CNDirection)direction
                                animated:(BOOL)animated
                              completion:(void (^)(void))completion
{
    [self.core dismissViewControllerToDirection:direction animated:animated completion:completion];
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

- (BOOL)supportsInteractiveTransition
{
    return YES;
}

#pragma mark - Autotransition

#pragma mark Storyboard

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

#pragma mark In Code

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

#pragma mark - CNPanGestureHandlerDelegate



#pragma mark - Private

- (void)initialize
{
    _core = [[CNViewControllerCore alloc] initWithViewController:self];
}

- (void)initializePanGestureRecognizer
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.panGestureHandler action:@selector(userDidPan:)];
    [self.view addGestureRecognizer:recognizer];
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

- (void)prepareForTransitionToDirection:(CNDirection)direction interactive:(BOOL)interactive
{
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.direction = direction;
    self.interactiveTransition.direction = direction;
    self.interactiveTransition.interactive = interactive;
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
