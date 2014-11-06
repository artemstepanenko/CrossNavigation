//
//  CNRightTransitioning.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/6/14.
//
//

import UIKit

class CNRightTransitioning: CNTransitioning {
   
    override func fromViewStartFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return containerFrame
    }
    
    override func toViewStartFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return CGRect.MoveHorizontally(containerFrame, xOffset: CGRectGetWidth(containerFrame))
    }
    
    override func fromViewEndFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return CGRect.MoveHorizontally(containerFrame, xOffset: -CGRectGetWidth(containerFrame))
    }
    
    override func toViewEndFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return containerFrame
    }
    
}
