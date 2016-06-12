//
//  CNTabBarController.m
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 17/05/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import "CNTabBarController.h"
#import "CNViewControllerCore.h"

@interface CNTabBarController ()

@property (nonatomic) CNViewControllerCore *core;

@end

@implementation CNTabBarController

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
    [self.core viewDidLoad];
}

- (void)presentViewController:(CNGenericViewController *)viewController
                    direction:(CNDirection)direction
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion
{
    [self.core presentViewController:viewController
                           direction:direction
                            animated:animated
                          completion:completion];
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

- (void)super_dismissViewControllerAnimated:(BOOL)animated
                                 completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:animated completion:completion];
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
    self.core.leftID = leftStoryboardID;
}

- (NSString *)leftID
{
    return self.core.leftID;
}

- (void)setTopID:(NSString *)topStoryboardID
{
    self.core.topID = topStoryboardID;
}

- (NSString *)topID
{
    return self.core.topID;
}

- (void)setRightID:(NSString *)rightStoryboardID
{
    self.core.rightID = rightStoryboardID;
}

- (NSString *)rightID
{
    return self.core.rightID;
}

- (void)setBottomID:(NSString *)bottomStoryboardID
{
    self.core.bottomID = bottomStoryboardID;
}

- (NSString *)bottomID
{
    return self.core.bottomID;
}

#pragma mark In Code

- (void)setLeftClass:(Class)leftClass
{
    self.core.leftClass = leftClass;
}

- (Class)leftClass
{
    return self.core.leftClass;
}

- (void)setTopClass:(Class)topClass
{
    self.core.topClass = topClass;
}

- (Class)topClass
{
    return self.core.topClass;
}

- (void)setRightClass:(Class)rightClass
{
    self.core.rightClass = rightClass;
}

- (Class)rightClass
{
    return self.core.rightClass;
}

- (void)setBottomClass:(Class)bottomClass
{
    self.core.bottomClass = bottomClass;
}

- (Class)bottomClass
{
    return self.core.bottomClass;
}

#pragma mark - Private

- (void)initialize
{
    _core = [[CNViewControllerCore alloc] initWithViewController:self];
}

@end
