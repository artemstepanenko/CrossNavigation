//
//  cn_direction.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/5/14.
//
//

import UIKit

enum CNDirection {
    
    case CNDirectionNone
    case CNDirectionLeft
    case CNDirectionTop
    case CNDirectionRight
    case CNDirectionBottom
    
    func CNDirectionGetOpposite() -> CNDirection {
        
        var opposite: CNDirection = .CNDirectionNone
        
        switch self {
        case .CNDirectionLeft:
            opposite = .CNDirectionRight
        case .CNDirectionRight:
            opposite = .CNDirectionLeft
        case .CNDirectionTop:
            opposite = .CNDirectionBottom
        case .CNDirectionBottom:
            opposite = .CNDirectionTop
        default:
            opposite = .CNDirectionNone
        }
        
        return opposite
    }
    
    func CNDirectionOppositeToDirection(direction: CNDirection) -> Bool {
    
        let oppositeDirection = direction.CNDirectionGetOpposite()
        
        if self == .CNDirectionNone || oppositeDirection == .CNDirectionNone {
            return false
        }
        
        return self == oppositeDirection
    }
    
    func CNDirectionIsHorizontal() -> Bool {
        return self == .CNDirectionLeft || self == .CNDirectionRight
    }
    
    func CNDirectionIsVertical() -> Bool {
        return self == .CNDirectionTop || self == .CNDirectionBottom
    }
    
}
