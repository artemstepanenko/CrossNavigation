//
// CNTimer.m
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

#import "CNTimer.h"

@interface CNTimer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger ticksCounter;
@property (nonatomic, assign) NSUInteger maxTicksCount;
@property (nonatomic, copy) CNTimerDidTick currentTickCallback;
@property (nonatomic, copy) CNTimerDidStop currentStopCallback;

@end

@implementation CNTimer

- (void)dealloc
{
    [self releaseTimer];
}

- (BOOL)isStarted
{
    if (self.timer) {
        return YES;
    } else {
        return NO;
    }
}

- (void)startWithTimeInterval:(NSTimeInterval)timeInterval
                 repeatsCount:(NSUInteger)count
                 tickCallback:(CNTimerDidTick)tickCallback
                 stopCallback:(CNTimerDidStop)stopCallback
{
    NSAssert(!self.timer, @"Timer instance mustn't be created so far");
    
    self.ticksCounter = 0;
    self.maxTicksCount = count;
    self.currentTickCallback = tickCallback;
    self.currentStopCallback = stopCallback;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                  target:self
                                                selector:@selector(timerDidTick)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)cancel
{
    [self stop:YES];
}

#pragma mark - Private

- (void)stop:(BOOL)cancelled
{
    [self releaseTimer];
    self.ticksCounter = 0;
    
    if (self.currentStopCallback) {
        self.currentStopCallback(cancelled);
    }
    
    self.currentStopCallback = nil;
    self.currentTickCallback = nil;
}

- (void)timerDidTick
{
    if (self.currentTickCallback) {
        self.currentTickCallback(self.ticksCounter);
    }
    
    self.ticksCounter++;
    
    if ((self.maxTicksCount > 0) && (self.ticksCounter >= self.maxTicksCount)) {
        [self stop:NO];
    }
}

- (void)releaseTimer
{
    if (self.timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        
        self.timer = nil;
    }
}

@end
