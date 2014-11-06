//
//  CNTopTransitioning.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/6/14.
//
//

import UIKit

class CNTopTransitioning: CNTransitioning {
    
    override func fromViewStartFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return containerFrame
    }
    
    override func toViewStartFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return CGRect.MoveVertically(containerFrame, yOffset: -CGRectGetHeight(containerFrame))
    }
    
    override func fromViewEndFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return CGRect.MoveVertically(containerFrame, yOffset: CGRectGetHeight(containerFrame))
    }
    
    override func toViewEndFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return containerFrame
    }
}
