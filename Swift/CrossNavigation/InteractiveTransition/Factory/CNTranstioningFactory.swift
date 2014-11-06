//
//  CNTranstioningFactory.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/5/14.
//
//

import UIKit

class CNTranstioningFactory: NSObject {
   
    class func Transitioning(direction: CNDirection, present: Bool) -> CNTransitioning? {
        
        if (direction == .Bottom && present) || (direction == .Top && !present) {
            return CNBottomTransitioning()
        } else if (direction == .Top && present) || (direction == .Bottom && !present) {
            return CNTopTransitioning()
        } else if (direction == .Left && present) || (direction == .Right && !present) {
            return CNLeftTransitioning()
        } else if (direction == .Right && present) || (direction == .Left && !present) {
            return CNRightTransitioning()
        }
        
        return nil
    }
    
}
