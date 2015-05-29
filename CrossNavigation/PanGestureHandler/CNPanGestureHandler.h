//
// CNPanGestureHandler.h
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
#import "cn_direction.h"

@class CNPanGestureHandler;

@protocol CNPanGestureHandlerDelegate <NSObject>

// events
- (void)panGestureHandler:(CNPanGestureHandler *)sender didStartForDirection:(CNDirection)direction;
- (void)panGestureHandler:(CNPanGestureHandler *)sender didUpdateWithRatio:(CGFloat)ratio;
- (void)panGestureHandlerDidFinish:(CNPanGestureHandler *)sender;
- (void)panGestureHandlerDidCancel:(CNPanGestureHandler *)sender;

// helpers
- (CNDirection)panGestureHandler:(CNPanGestureHandler *)sender directionForOffset:(CGPoint)offset;
- (CGPoint)panGestureHandler:(CNPanGestureHandler *)sender locationOfGesture:(UIPanGestureRecognizer *)gestureRecognizer;
- (CGSize)viewSizeForPanGestureHandler:(CNPanGestureHandler *)sender;

@end

@interface CNPanGestureHandler : NSObject

- (instancetype)initWithDelegate:(id<CNPanGestureHandlerDelegate>)delegate;
- (void)userDidPan:(UIPanGestureRecognizer *)recognizer;

@end
