//
//  CNTabBarController.m
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 17/05/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import "CNTabBarController.h"

@implementation CNTabBarController

@synthesize leftClass = _leftClass;
@synthesize rightClass = _rightClass;
@synthesize topClass = _topClass;
@synthesize bottomClass = _bottomClass;
@synthesize leftID = _leftID;
@synthesize rightID = _rightID;
@synthesize topID = _topID;
@synthesize bottomID = _bottomID;

- (void)presentViewController:(UIViewController<CNViewControllerProtocol> *)viewController
                    direction:(CNDirection)direction
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion
{
    
}

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    
}

- (void)dismissViewControllerToDirection:(CNDirection)direction
                                animated:(BOOL)animated
                              completion:(void (^)(void))completion
{
    
}

- (void)viewIsAppearing:(CGFloat)percentComplete
{
    
}

- (BOOL)shouldAutotransitToDirection:(CNDirection)direction present:(BOOL)present
{
    return NO;
}

- (BOOL)supportsInteractiveTransition
{
    return NO;
}

@end
