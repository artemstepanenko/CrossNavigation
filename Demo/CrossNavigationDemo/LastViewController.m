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
    CNViewController *firstViewController = (CNViewController *)self.presentingViewController;
    [self dismissViewControllerToDirection:CNDirectionTop animated:YES completion:nil];
}

@end
