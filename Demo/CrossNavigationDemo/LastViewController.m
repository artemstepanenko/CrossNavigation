//
//  LastViewController.m
//  CrossNavigationDemo
//
//  Created by Artem Stepanenko on 1/8/15.
//  Copyright (c) 2015 Artem Stepanenko. All rights reserved.
//

#import "LastViewController.h"

@interface LastViewController ()

@end

@implementation LastViewController

- (IBAction)restartDidPress:(id)sender
{
    CNViewController *firstViewController = (CNViewController *)self.presentingViewController.presentingViewController;
    [firstViewController dismissViewControllerToDirection:CNDirectionLeft animated:NO completion:nil];
}

@end
