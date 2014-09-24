//
// CNTransitioningFactory.m
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

#import "CNTransitioningFactory.h"
#import "CNTopTransitioning.h"
#import "CNLeftTransitioning.h"
#import "CNBottomTransitioning.h"
#import "CNRightTransitioning.h"

@implementation CNTransitioningFactory

+ (CNTransitioning *)transitioningForDirection:(CNDirection)direction present:(BOOL)present
{
    if ((direction == CNDirectionLeft && present == YES) || (direction == CNDirectionRight && present == NO))
    {
        return [CNLeftTransitioning new];
    }
    else if ((direction == CNDirectionRight && present == YES) || (direction == CNDirectionLeft && present == NO))
    {
        return [CNRightTransitioning new];
    }
    else if ((direction == CNDirectionTop && present == YES) || (direction == CNDirectionBottom && present == NO))
    {
        return [CNTopTransitioning new];
    }
    else if ((direction == CNDirectionBottom && present == YES) || (direction == CNDirectionTop && present == NO))
    {
        return [CNBottomTransitioning new];
    }
    
    NSAssert(NO, @"Wrong parameters, can't pick up any transition");
    return nil;
}

@end
