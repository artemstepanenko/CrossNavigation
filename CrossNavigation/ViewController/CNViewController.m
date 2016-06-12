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
#import "CNViewControllerCore.h"

@interface CNViewController ()

@property (nonatomic) CNViewControllerCore *cn_core;

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
    [self.cn_core viewDidLoad];
}

- (void)presentViewController:(CNGenericViewController *)viewController
                    direction:(CNDirection)direction
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion
{
    [self.cn_core presentViewController:viewController
                              direction:direction
                               animated:animated
                             completion:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)animated
                           completion:(void (^)(void))completion
{
    [self.cn_core dismissViewControllerAnimated:animated completion:completion];
}

- (void)dismissViewControllerToDirection:(CNDirection)direction
                                animated:(BOOL)animated
                              completion:(void (^)(void))completion
{
    [self.cn_core dismissViewControllerToDirection:direction animated:animated completion:completion];
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

#pragma mark Storyboard

- (void)setLeftID:(NSString *)leftStoryboardID
{
    self.cn_core.leftID = leftStoryboardID;
}

- (NSString *)leftID
{
    return self.cn_core.leftID;
}

- (void)setTopID:(NSString *)topStoryboardID
{
    self.cn_core.topID = topStoryboardID;
}

- (NSString *)topID
{
    return self.cn_core.topID;
}

- (void)setRightID:(NSString *)rightStoryboardID
{
    self.cn_core.rightID = rightStoryboardID;
}

- (NSString *)rightID
{
    return self.cn_core.rightID;
}

- (void)setBottomID:(NSString *)bottomStoryboardID
{
    self.cn_core.bottomID = bottomStoryboardID;
}

- (NSString *)bottomID
{
    return self.cn_core.bottomID;
}

#pragma mark In Code

- (void)setLeftClass:(Class)leftClass
{
    self.cn_core.leftClass = leftClass;
}

- (Class)leftClass
{
    return self.cn_core.leftClass;
}

- (void)setTopClass:(Class)topClass
{
    self.cn_core.topClass = topClass;
}

- (Class)topClass
{
    return self.cn_core.topClass;
}

- (void)setRightClass:(Class)rightClass
{
    self.cn_core.rightClass = rightClass;
}

- (Class)rightClass
{
    return self.cn_core.rightClass;
}

- (void)setBottomClass:(Class)bottomClass
{
    self.cn_core.bottomClass = bottomClass;
}

- (Class)bottomClass
{
    return self.cn_core.bottomClass;
}

#pragma mark - Private

- (void)initialize
{
    _cn_core = [[CNViewControllerCore alloc] initWithViewController:self];
}

@end
