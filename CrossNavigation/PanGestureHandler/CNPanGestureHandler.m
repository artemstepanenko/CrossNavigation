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
        self.delegate = delegate;
        [self resetStateFlags];
    }
    
    return self;
}

- (void)userDidPan:(UIPanGestureRecognizer *)recognizer
{
    // checks if this event should be handled
    if (!self.shouldHandle) {

        // check if unhandled gesture ends
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            [self resetStateFlags];
        }
        
        return;
    }
    
    // calculate gesture offset
    CGPoint location = [self.delegate panGestureHandler:self locationOfGesture:recognizer];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.startPanPoint = location;
        return;
    }
    
    CGPoint offset = CGPointMake(location.x - self.startPanPoint.x, location.y - self.startPanPoint.y);
    
    // gets direction by offset, finds out if this direction should be handled
    if (!self.isDirectionDetected) {
        
        self.isDirectionDetected = YES;
        self.direction = [self.delegate panGestureHandler:self directionForOffset:offset];
        
        if (self.direction == CNDirectionNone) {
            self.shouldHandle = NO;
        } else {
            [self notifyDelegateAboutStart];
        }
        
        return;
    }
    
    // calculates ratio
    CGFloat ratio = [self ratioFromLocation:offset direction:self.direction];
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {

        [self updateRatio:ratio];
        [self notifyDelegateAboutUpdate];
        return;
    }
    
    // finish handling
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [self notifyDelegateAboutFinishOrCancel];
        [self resetStateFlags];
    }
}

#pragma mark - Private

- (void)updateRatio:(CGFloat)ratio
{
    if (ratio != self.recentRatio) {
        
        self.recentFinish = (ratio > self.recentRatio);
        self.recentRatio = ratio;
    }
}

- (void)notifyDelegateAboutStart
{
    [self.delegate panGestureHandler:self didStartForDirection:self.direction];
}

- (void)notifyDelegateAboutUpdate
{
    [self.delegate panGestureHandler:self didUpdateWithRatio:self.recentRatio];
}

- (void)notifyDelegateAboutFinishOrCancel
{
    if (self.recentFinish) {
        [self.delegate panGestureHandlerDidFinish:self];
    } else {
        [self.delegate panGestureHandlerDidCancel:self];
    }
}

- (void)resetStateFlags
{
    self.isDirectionDetected = NO;
    self.shouldHandle = YES;
    self.recentRatio = CGFLOAT_MIN;
    self.recentFinish = NO;
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
