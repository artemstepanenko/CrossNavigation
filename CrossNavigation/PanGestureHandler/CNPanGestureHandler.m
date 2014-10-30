//
// CNPanGestureHandler.m
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

#import "CNPanGestureHandler.h"

@interface CNPanGestureHandler ()

@property (nonatomic, assign) BOOL shouldHandle;
@property (nonatomic, assign) BOOL isDirectionDetected;
@property (nonatomic, assign) CGPoint startPanPoint;
@property (nonatomic, assign) CGFloat recentRatio;
@property (nonatomic, assign) BOOL recentFinish;
@property (nonatomic, assign) CNDirection direction;

@property (nonatomic, weak) id<CNPanGestureHandlerDelegate> delegate;

@end

@implementation CNPanGestureHandler

- (instancetype)initWithDelegate:(id<CNPanGestureHandlerDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        self.shouldHandle = YES;
        self.isDirectionDetected = NO;
        self.delegate = delegate;
    }
    
    return self;
}

- (void)userDidPan:(UIPanGestureRecognizer *)recognizer
{
    // 0. if direction is not available, we don't have to handle it
    if (!self.shouldHandle) {
        
        // wait for the end of a gesture to unavailable direction and return flags to an initial state
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            
            self.isDirectionDetected = NO;
            self.shouldHandle = YES;
        }
        
        return;
    }
    
    // save current pan location
    CGPoint location = [self.delegate panGestureHandler:self locationOfGesture:recognizer];
    
    // reset a start point, a ration and a 'finish' flag
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        self.startPanPoint = location;
        self.recentRatio = CGFLOAT_MIN;
        self.recentFinish = NO;
        return;
    }
    
    // save a current gesture offset
    CGPoint offset = CGPointMake(location.x - self.startPanPoint.x, location.y - self.startPanPoint.y);
    
    // when an offset is detected for the first time, we need to calculate direction and find out if it's available
    if (!self.isDirectionDetected) {
        
        self.isDirectionDetected = YES;
        self.direction = [self.delegate panGestureHandler:self directionForOffset:offset];
        
        if (self.direction == CNDirectionNone) {
            // direction is unavailable, so we set a flag to prevent further handling
            self.shouldHandle = NO;
        } else {
            // 1. direction is available, notify delegate that handling is started
            [self.delegate panGestureHandler:self didStartForDirection:self.direction];
        }
        
        return;
    }
    
    // calculate ratio depends on a given direction and the gesture offset
    CGFloat ratio = [self ratioFromLocation:offset direction:self.direction];
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {

        if (ratio != self.recentRatio) {
            
            // determine a sign (positive or negative) of a ratio change
            // if it's positive and gesture will finish within the next update, a transition would finish,
            // otherwise it would cancel
            self.recentFinish = (ratio > self.recentRatio);
            
            // this is a ratio of the transition
            self.recentRatio = ratio;
        }
        
        // 2. inform the delegate that the ratio is changed
        [self.delegate panGestureHandler:self didUpdateWithRatio:ratio];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        // 3. send finish or cancel event to the delegate depends on the flag
        if (self.recentFinish) {
            [self.delegate panGestureHandlerDidFinish:self];
        } else {
            [self.delegate panGestureHandlerDidCancel:self];
        }
        
        // return flags to an initial state
        self.isDirectionDetected = NO;
        self.shouldHandle = YES;
    }
}

- (CGFloat)ratioFromLocation:(CGPoint)location direction:(CNDirection)direction
{
    CGFloat edge;
    CGFloat distance;
    CGSize size = [self.delegate viewSizeForPanGestureHandler:self];
    
    if (CNDirectionIsHorizontal(direction)) {
        
        edge = size.width;
        distance = location.x;
        distance *= (self.direction == CNDirectionRight ? -1 : 1);
        
    } else if (CNDirectionIsVertical(direction)) {
        
        edge = size.height;
        distance = location.y;
        distance *= (self.direction == CNDirectionBottom ? -1 : 1);
        
    } else {
        NSAssert(NO, @"Unknown direction");
    }
    
    return distance / edge;
}

@end
