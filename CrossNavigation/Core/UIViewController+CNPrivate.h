//
//  UIViewController+CNPrivate.h
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 5/19/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CNViewControllerCore;

@interface UIViewController (CNPrivate)

@property (nonatomic, readonly) CNViewControllerCore *cn_core;

+ (NSDictionary *)cn_createParamsForDismissAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)cn_super_dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)cn_dismissWithParams:(NSDictionary *)params;

@end
