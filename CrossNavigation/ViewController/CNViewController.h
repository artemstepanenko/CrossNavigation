//
// CNViewController.h
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

#import <UIKit/UIKit.h>
#import "CNViewControllerProtocol.h"

/**
 if you inherit your view controllers from CNViewController, you'll be able to push them to the stack not just to right side (as you do if you use UINavigationController), but to any of four: left, top, right, bottom. Supports autorotations.
 
 @see CNViewController_Storyboard.h
 */

@interface CNViewController : UIViewController <CNViewControllerProtocol>

@property (nonatomic) IBInspectable NSString *leftID;
@property (nonatomic) IBInspectable NSString *topID;
@property (nonatomic) IBInspectable NSString *rightID;
@property (nonatomic) IBInspectable NSString *bottomID;

@end
