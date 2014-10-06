//
//  ViewController.m
//  CrossNavigationDemo
//
//  Created by Artem Stepanenko on 10/1/14.
//  Copyright (c) 2014 Artem Stepanenko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *navigationSignViews;


@end

@implementation ViewController

- (void)viewIsAppearing:(CGFloat)percentComplete
{
    for (UIView *signView in self.navigationSignViews) {
        signView.alpha = percentComplete;
    }
}

- (BOOL)shouldAutotransitToDirection:(CNDirection)direction present:(BOOL)present
{
    // ...
    return YES;
}

@end
