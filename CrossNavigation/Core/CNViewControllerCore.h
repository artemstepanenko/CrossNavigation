//
// CNViewControllerCore.h
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

#import <Foundation/Foundation.h>
#import "CNViewControllerProtocol.h"
#import "CNGenericViewController.h"
#import "cn_direction.h"

@interface CNViewControllerCore : NSObject

@property (nonatomic, copy) NSString *leftID;
@property (nonatomic, copy) NSString *topID;
@property (nonatomic, copy) NSString *rightID;
@property (nonatomic, copy) NSString *bottomID;
@property (nonatomic) Class leftClass;
@property (nonatomic) Class topClass;
@property (nonatomic) Class rightClass;
@property (nonatomic) Class bottomClass;

- (instancetype)initWithViewController:(CNGenericViewController *)viewController;

- (void)presentViewController:(CNGenericViewController *)viewController
                    direction:(CNDirection)direction
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion;

- (void)dismissViewControllerAnimated:(BOOL)animated
                           completion:(void (^)(void))completion;

- (void)dismissViewControllerToDirection:(CNDirection)direction
                                animated:(BOOL)animated
                              completion:(void (^)(void))completion;

- (void)viewDidLoad;

@end
