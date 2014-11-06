//
//  CNTransitioning.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/5/14.
//
//

import UIKit

class CNTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
   
    var presenting: Bool = true
    var duration: NSTimeInterval { get { return 0.3 } }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // container
        let containerView = transitionContext.containerView()
        let containerBounds = containerView.bounds
        
        // from
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var fromView = fromViewController!.view
        fromView.frame = self.fromViewStartFrameWithContainerFrame(containerBounds)
        
        // to
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        var toView = toViewController!.view
        toView.frame = self.toViewStartFrameWithContainerFrame(containerBounds)
        containerView.addSubview(toView)
        
        // transition
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in
            fromView.frame = self.fromViewEndFrameWithContainerFrame(containerBounds)
            toView.frame = self.toViewEndFrameWithContainerFrame(containerBounds)
        }) { (completion: Bool) -> Void in
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return self.duration
    }
    
    // MARK: Public methods
    
    func fromViewStartFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return CGRectZero
    }
    
    func toViewStartFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return CGRectZero
    }
    
    func fromViewEndFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return CGRectZero
    }
    
    func toViewEndFrameWithContainerFrame(containerFrame: CGRect) -> CGRect {
        return CGRectZero
    }
    
}
