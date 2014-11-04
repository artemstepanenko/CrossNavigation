//
//  TableViewController.m
//  CrossNavigationDemo
//
//  Created by Artem Stepanenko on 11/4/14.
//  Copyright (c) 2014 Artem Stepanenko. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController () <UITableViewDelegate>

@end

@implementation TableViewController

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    
    if (offset < -80) {
        CNViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"some_screen"];
        [self presentViewController:viewController direction:CNDirectionTop animated:YES completion:nil];
    }
}

@end
