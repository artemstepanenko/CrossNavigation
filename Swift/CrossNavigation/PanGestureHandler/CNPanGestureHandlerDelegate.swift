//
//  CNPanGestureHandlerDelegate.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/5/14.
//
//

import UIKit

protocol CNPanGestureHandlerDelegate {
    
    // Events
    func didStartForDirection(sender: CNPanGestureHandler, direction: CNDirection)
    func didUpdateWithRatio(sender: CNPanGestureHandler, ratio: CGFloat)
    func didFinish(sender: CNPanGestureHandler)
    func didCancel(sender: CNPanGestureHandler)
    
    // Helpers
    func directionForOffset(sender: CNPanGestureHandler, offset: CGPoint) -> CNDirection
    func locationOfGesture(sender: CNPanGestureHandler, gestureRecognizer: UIPanGestureRecognizer) -> CGPoint
    func viewSizeForPanGestureHandler(sender: CNPanGestureHandler) -> CGSize
}