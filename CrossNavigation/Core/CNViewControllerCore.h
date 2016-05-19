//
//  CNViewControllerCore.h
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 5/19/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cn_direction.h"

@class UIViewController;
@protocol CNViewControllerProtocol;

@interface CNViewControllerCore : NSObject

- (instancetype)initWithViewController:(UIViewController<CNViewControllerProtocol> *)viewController;

- (void)dismissViewControllerAnimated:(BOOL)animated
                           completion:(void (^)(void))completion;

- (void)dismissViewControllerToDirection:(CNDirection)direction
                                animated:(BOOL)animated
                              completion:(void (^)(void))completion;

@end
