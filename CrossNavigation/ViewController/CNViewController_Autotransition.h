//
// CNViewController_Autotransition.h
//
// Copyright (c) 2014 Artem Stepanenko
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

#import "CNViewController.h"

/**
 Use methods/properties from this interface to implement auto-transitions.
 It means that following view controllers are presented automatically when a user makes a proper dragging gesture.
 */
@interface CNViewController ()

#pragma mark Storyboard

/**
 Properties for storybord's identifiers of following view controllers. One - for each direction.
 If appropriate view controller is set, user can make an interactive transition by dragging.
 
 @warning storyboard identifiers must belong to instances of CNViewController or any other classes inherited from CNViewController
 @warning view controllers must be in the same storyboard
 */

/**
 Specifies the following left view controller's storyboard identifier.
 */
@property (nonatomic, strong) IBInspectable NSString *leftID;

/**
 Specifies the following top view controller's storyboard identifier.
 */
@property (nonatomic, strong) IBInspectable NSString *topID;

/**
 Specifies the following right view controller's storyboard identifier.
 */
@property (nonatomic, strong) IBInspectable NSString *rightID;

/**
 Specifies the following bottom view controller's storyboard identifier.
 */
@property (nonatomic, strong) IBInspectable NSString *bottomID;

#pragma mark In Code

/**
 Properties for classes of following view controllers.
 Actual instances are created using the most simple initializer:
 
 CNViewController *cnViewController = [[cnClass new] init];
 
 @warning provided classes must be CNViewController or any other classes inherited from CNViewController
 */

/**
 Specifies the following left view controller's class.
 */
@property (nonatomic, strong) Class leftClass;

/**
 Specifies the following top view controller's class.
 */
@property (nonatomic, strong) Class topClass;

/**
 Specifies the following right view controller's class.
 */
@property (nonatomic, strong) Class rightClass;

/**
 Specifies the following bottom view controller's class.
 */
@property (nonatomic, strong) Class bottomClass;

@end
