//
//  DefaultViewController.h
//  CrossNavigationDemo
//
//  Created by Artem Stepanenko on 5/17/15.
//  Copyright (c) 2015 Artem Stepanenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DefaultViewController;

@protocol DefaultViewControllerDelegate <NSObject>

- (void)shouldCloseModal;

@end

@interface DefaultViewController : UIViewController

@property (nonatomic, weak) id <DefaultViewControllerDelegate> delegate;

@end
