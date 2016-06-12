//
//  UIViewController+CNPrivate.h
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 5/19/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CNPrivate)

- (void)cn_dismissWithParams:(NSDictionary *)params;
+ (NSDictionary *)cn_createParamsForDismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
