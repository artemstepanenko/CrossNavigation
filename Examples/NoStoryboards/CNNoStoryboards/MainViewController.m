//
//  MainViewController.m
//  CNNoStoryboards
//
//  Created by Artem Stepanenko on 5/28/15.
//  Copyright (c) 2015 Artem Stepanenko. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] init];
    self.label.text = @"Drag to change a screen";
    [self.label sizeToFit];
    [self.view addSubview:self.label];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.label.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
}

- (BOOL)shouldAutotransitToDirection:(CNDirection)direction present:(BOOL)present
{
    return YES;
}

@end
