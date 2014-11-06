//
//  CNBottomTransitioning.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/5/14.
//
//

import UIKit

class CNBottomTransitioning: CNTransitioning {
    
    override func fromViewStartFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return containerFrame
    }
    
    override func toViewStartFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return CGRect.MoveVertically(containerFrame, yOffset: CGRectGetHeight(containerFrame))
    }

    override func fromViewEndFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return CGRect.MoveVertically(containerFrame, yOffset: -CGRectGetHeight(containerFrame))
    }

    override func toViewEndFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return containerFrame
    }
}
