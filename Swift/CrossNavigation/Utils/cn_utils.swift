//
//  cn_utils.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/5/14.
//
//

import UIKit

extension CGRect {
    
    static func MoveVertically(rect: CGRect, yOffset: CGFloat) -> CGRect {
        return CGRect(x: CGRectGetMinX(rect), y: CGRectGetMinY(rect) + yOffset, width: CGRectGetWidth(rect), height: CGRectGetHeight(rect))
    }
    
    static func MoveHorizontally(rect: CGRect, xOffset: CGFloat) -> CGRect {
        return CGRect(x: CGRectGetMinX(rect) + xOffset, y: CGRectGetMinY(rect), width: CGRectGetWidth(rect), height: CGRectGetHeight(rect))
    }
    
    static func Transform(originRect: CGRect, finalRect: CGRect, rate: CGFloat) -> CGRect {
        return CGRect(x: CGRectGetMinX(originRect) + rate * (CGRectGetMinX(finalRect) - CGRectGetMinX(originRect)),
            y: CGRectGetMinY(originRect) + rate * (CGRectGetMinY(finalRect) - CGRectGetMinY(originRect)),
            width: CGRectGetWidth(originRect) + rate * (CGRectGetWidth(finalRect) - CGRectGetWidth(originRect)),
            height: CGRectGetHeight(originRect) + rate * (CGRectGetHeight(finalRect) - CGRectGetHeight(originRect)))
    }
    
}