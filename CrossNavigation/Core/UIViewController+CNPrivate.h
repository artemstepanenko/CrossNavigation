//
//  UIViewController+CNPrivate.h
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 5/19/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CNPrivate)

- (void)dismissWithParams:(NSDictionary *)params;
+ (NSDictionary *)createParamsForDismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
