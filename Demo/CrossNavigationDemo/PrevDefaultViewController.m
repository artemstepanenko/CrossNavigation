//
//  PrevDefaultViewController.m
//  CrossNavigationDemo
//
//  Created by Artem Stepanenko on 5/17/15.
//  Copyright (c) 2015 Artem Stepanenko. All rights reserved.
//

#import "PrevDefaultViewController.h"
#import "DefaultViewController.h"

@interface PrevDefaultViewController () <DefaultViewControllerDelegate>

@end

@implementation PrevDefaultViewController

- (IBAction)showDefaultModal:(id)sender
{
    DefaultViewController *modalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"default"];
    modalViewController.delegate = self;
    [self presentViewController:modalViewController animated:YES completion:nil];
}

#pragma mark - DefaultViewControllerDelegate

- (void)shouldCloseModal
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
