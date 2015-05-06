//
// cn_direction.h
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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CNDirection)
{
    CNDirectionNone = 0,
    CNDirectionLeft,
    CNDirectionTop,
    CNDirectionRight,
    CNDirectionBottom,
};

static CNDirection CNDirectionGetOpposite(CNDirection direction)
{
    switch (direction) {
        case CNDirectionLeft:
            return CNDirectionRight;
            
        case CNDirectionRight:
            return CNDirectionLeft;
            
        case CNDirectionTop:
            return CNDirectionBottom;
            
        case CNDirectionBottom:
            return CNDirectionTop;
            
        default:
            return CNDirectionNone;
    }
}

static BOOL CNDirectionOppositeToDirection(CNDirection direction1, CNDirection direction2)
{
    CNDirection oppositeDirection = CNDirectionGetOpposite(direction2);
    
    if ((direction1 == CNDirectionNone) || (oppositeDirection == CNDirectionNone)) {
        return NO;
    }
    
    return direction1 == oppositeDirection;
}

static BOOL CNDirectionIsHorizontal(CNDirection direction)
{
    return (direction == CNDirectionLeft) || (direction == CNDirectionRight);
}

static BOOL CNDirectionIsVertical(CNDirection direction)
{
    return (direction == CNDirectionTop) || (direction == CNDirectionBottom);
}
