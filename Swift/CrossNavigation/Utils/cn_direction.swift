//
//  cn_direction.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/5/14.
//
//

import UIKit

enum CNDirection {
    
    case None
    case Left
    case Top
    case Right
    case Bottom
    
    func getOpposite() -> CNDirection {
        
        var opposite: CNDirection = .None
        
        switch self {
        case .Left:
            opposite = .Right
        case .Right:
            opposite = .Left
        case .Top:
            opposite = .Bottom
        case .Bottom:
            opposite = .Top
        default:
            opposite = .None
        }
        
        return opposite
    }
    
    func oppositeToDirection(direction: CNDirection) -> Bool {
    
        let oppositeDirection = direction.getOpposite()
        
        if self == .None || oppositeDirection == .None {
            return false
        }
        
        return self == oppositeDirection
    }
    
    func isHorizontal() -> Bool {
        return self == .Left || self == .Right
    }
    
    func isVertical() -> Bool {
        return self == .Top || self == .Bottom
    }
    
}
