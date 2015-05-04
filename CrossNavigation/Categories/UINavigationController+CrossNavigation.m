//
//  UINavigationController+CrossNavigation.m
//  CrossNavigationDemo
//
//  Created by Artem Stepanenko on 5/4/15.
//  Copyright (c) 2015 Artem Stepanenko. All rights reserved.
//

#import "UINavigationController+CrossNavigation.h"
#import "CNViewController.h"

@implementation UINavigationController (CrossNavigation)

- (void)viewIsAppearing:(CGFloat)percentComplete
{
    UIViewController *lastViewController = self.viewControllers.lastObject;
    
    if ([lastViewController isKindOfClass:[CNViewController class]]) {

        CNViewController *cnViewController = (CNViewController *)lastViewController;
        [cnViewController viewIsAppearing:percentComplete];
    }
}

@end
