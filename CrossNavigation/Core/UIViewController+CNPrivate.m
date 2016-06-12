//
//  UIViewController+CNPrivate.m
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 5/19/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import "UIViewController+CNPrivate.h"
#import <objc/runtime.h>

NSString *const kCNAnimated = @"animated";
NSString *const kCNCompletion = @"completion";

@implementation UIViewController (CNPrivate)

@dynamic cn_core;

+ (NSDictionary *)cn_createParamsForDismissAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[kCNAnimated] = @(animated);
    
    if (completion) {
        params[kCNCompletion] = completion;
    }
    
    return params;
}

- (void)cn_dismissWithParams:(NSDictionary *)params
{
    [self dismissViewControllerAnimated:[params[kCNAnimated] boolValue] completion:params[kCNCompletion]];
}

- (void)cn_super_dismissViewControllerAnimated:(BOOL)animated
                                    completion:(void (^)(void))completion
{
    SEL sel = @selector(dismissViewControllerAnimated:completion:);
     void (* imp)(id, SEL, BOOL, void (^)(void)) = (void (*)(id, SEL, BOOL, void (^)(void)))class_getMethodImplementation([UIViewController class], sel);
    imp(self, sel, animated, completion);
}

@end
