//
// UIViewController+CNPrivate.m
//
// Copyright (c) 2016 Artem Stepanenko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
