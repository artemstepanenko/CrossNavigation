//
//  CNPanGestureHandler.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/5/14.
//
//

import UIKit

class CNPanGestureHandler : NSObject {
   
    private var shouldHandle: Bool = true
    private var isDirectionDetected: Bool = false
    private var startPanPoint: CGPoint = CGPointZero
    private var recentRatio: CGFloat = CGFloat.min
    private var recentFinish: Bool = false
    private var direction: CNDirection = .None
    private var delegate: CNPanGestureHandlerDelegate?
    
    // Public methods
    
    init(delegate: CNPanGestureHandlerDelegate) {
        super.init()
        
        self.delegate = delegate
        self.resetStateFlags()
    }
    
    func userDidPan(recognizer: UIPanGestureRecognizer) -> () {

        // checks if this event should be handled
        if !self.shouldHandle {
            
            // check if unhandled gesture ends
            if recognizer.state == UIGestureRecognizerState.Ended {
                self.resetStateFlags()
            }
            
            return
        }
        
        // calculate gesture offset
        let location = self.delegate?.locationOfGesture(self, gestureRecognizer: recognizer)
        
        if recognizer.state == UIGestureRecognizerState.Began {
            self.startPanPoint = location!
            return
        }
        
        // gets direction by offset, finds out if this direction should be handled
        let offset = CGPointMake(location!.x - self.startPanPoint.x, location!.y - self.startPanPoint.y)
        
        if !self.isDirectionDetected {
            self.isDirectionDetected = true
            self.direction = self.delegate!.directionForOffset(self, offset: offset)
            
            if self.direction == .None {
                self.shouldHandle = false
            } else {
                self.notifyDelegateAboutStart()
            }
            
            return
        }
        
        // calculates ratio
        let ratio = self.ratioFromLocation(offset, direction: self.direction)
        
        if recognizer.state == UIGestureRecognizerState.Changed {
            self.updateRatio(ratio)
            self.notifyDelegateAboutUpdate()
            return
        }
        
        // finish handling
        if recognizer.state == UIGestureRecognizerState.Ended {
            self.notifyDelegateAboutFinishOrCancel()
            self.resetStateFlags()
        }
    }
    
    
    // Private methods
    private func resetStateFlags() -> () {
        self.isDirectionDetected = false
        self.shouldHandle = true
        self.recentRatio = CGFloat.min
        self.recentFinish = false
    }
    
    private func notifyDelegateAboutStart() -> () {
        self.delegate?.didStartForDirection(self, direction: self.direction)
    }
    
    private func notifyDelegateAboutUpdate() -> () {
        self.delegate?.didUpdateWithRatio(self, ratio: self.recentRatio)
    }
    
    private func notifyDelegateAboutFinishOrCancel() -> () {
        if self.recentFinish {
            self.delegate?.didFinish(self)
        } else {
            self.delegate?.didCancel(self)
        }
    }
    
    private func ratioFromLocation(location: CGPoint, direction: CNDirection) -> CGFloat {
        var edge: CGFloat = 0.0
        var distance: CGFloat = 0.0
        var size = self.delegate!.viewSizeForPanGestureHandler(self)
        
        if direction.isHorizontal() {
            edge = size.width
            distance = location.x
            distance *= (self.direction == .Right ? -1 : 1)
        } else if direction.isVertical() {
            edge = size.height
            distance = location.y
            distance *= (self.direction == .Bottom ? -1 : 1)
        }
        
        return distance / edge
    }
    
    private func updateRatio(ratio: CGFloat) -> () {
        if ratio != self.recentRatio {
            self.recentFinish = (ratio > self.recentRatio)
            self.recentRatio = ratio
        }
    }
    
}
