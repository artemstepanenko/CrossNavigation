//
// cn_utils.h
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

static CGRect CGRectMoveVertically(CGRect rect, CGFloat yOffset)
{
    return CGRectMake(CGRectGetMinX(rect),
                      CGRectGetMinY(rect) + yOffset,
                      CGRectGetWidth(rect),
                      CGRectGetHeight(rect));
}

static CGRect CGRectMoveHorizontally(CGRect rect, CGFloat xOffset)
{
    return CGRectMake(CGRectGetMinX(rect) + xOffset,
                      CGRectGetMinY(rect),
                      CGRectGetWidth(rect),
                      CGRectGetHeight(rect));
}

static CGRect CGRectTransform(CGRect originRect, CGRect finalRect, CGFloat rate)
{
    return CGRectMake(CGRectGetMinX(originRect) + rate * (CGRectGetMinX(finalRect) - CGRectGetMinX(originRect)),
                      CGRectGetMinY(originRect) + rate * (CGRectGetMinY(finalRect) - CGRectGetMinY(originRect)),
                      CGRectGetWidth(originRect) + rate * (CGRectGetWidth(finalRect) - CGRectGetWidth(originRect)),
                      CGRectGetHeight(originRect) + rate * (CGRectGetHeight(finalRect) - CGRectGetHeight(originRect)));
}
