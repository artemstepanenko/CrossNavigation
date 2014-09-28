//
//  AppearingViewController.m
//  CrossNavigationDemo
//
//  Created by Artem Stepanenko on 9/27/14.
//  Copyright (c) 2014 Artem Stepanenko. All rights reserved.
//

#import "AppearingViewController.h"

@interface AppearingViewController ()

@property (nonatomic, weak) IBOutlet UILabel *progressLabel;

@end

@implementation AppearingViewController

- (void)viewIsAppearing:(CGFloat)percentComplete
{
    [super viewIsAppearing:percentComplete];
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f", percentComplete];
}

- (IBAction)nextDidPress:(id)sender
{
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"alone"]
                      direction:CNDirectionTop
                       animated:YES];
}

- (IBAction)backDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
