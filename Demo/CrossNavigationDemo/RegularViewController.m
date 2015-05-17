//
//  RegularViewController.m
//  CrossNavigationDemo
//
//  Created by Artem Stepanenko on 5/17/15.
//  Copyright (c) 2015 Artem Stepanenko. All rights reserved.
//

#import "RegularViewController.h"

@implementation RegularViewController

- (IBAction)showModalDidPress:(id)sender
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"default"];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
