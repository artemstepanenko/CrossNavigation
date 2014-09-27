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
    self.progressLabel.text = [NSString stringWithFormat:@"A: %.2f", percentComplete];
}

- (void)viewIsDisappearing:(CGFloat)percentComplete
{
    [super viewIsDisappearing:percentComplete];
    self.progressLabel.text = [NSString stringWithFormat:@"D: %.2f", percentComplete];
}

@end
