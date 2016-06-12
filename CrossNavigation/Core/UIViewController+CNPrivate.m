//
//  UIViewController+CNPrivate.m
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 5/19/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import "UIViewController+CNPrivate.h"

@implementation UIViewController (CNPrivate)

+ (NSDictionary *)cn_createParamsForDismissAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    // params
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"animated"] = @(animated);
    
    if (completion) {
        params[@"completion"] = completion;
    }
    
    return params;
}

- (void)cn_dismissWithParams:(NSDictionary *)params
{
    [self dismissViewControllerAnimated:[params[@"animated"] boolValue] completion:params[@"completion"]];
}

@end
