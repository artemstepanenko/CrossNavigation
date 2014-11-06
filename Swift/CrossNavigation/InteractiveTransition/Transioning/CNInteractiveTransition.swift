//
//  CNInteractiveTransition.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/5/14.
//
//

import UIKit

class CNInteractiveTransition: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate {
   
    // private vars
    private var appearanceTransitioning: CNTransitioning?
    private var disappearanceTransitioning: CNTransitioning?
    private var transitionContext: UIViewControllerContextTransitioning?
    private var interactive: Bool = true

    // read-only
    private(set) var fromViewController: CNViewController?
    private(set) var toViewController: CNViewController?
    private(set) var containerView: UIView?
    private(set) var recentPercentComplete: CGFloat = 0

    // public var
    var finishingDuration: CGFloat = CGFloat(CNTransitioning().duration)
    var direction: CNDirection {
        didSet {
            self.appearanceTransitioning = CNTranstioningFactory.Transitioning(direction, present: true)
            self.disappearanceTransitioning = CNTranstioningFactory.Transitioning(direction, present: false)
        }
    }
    
    override init() {
        self.direction = .None
    }
    
    // MARK: Interactive Transtioning
    
    override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) -> () {
        self.transitionContext = transitionContext
        self.containerView = self.transitionContext!.containerView()
        
        let containerFrame = self.containerView!.bounds
        
        // from View Controller
        self.fromViewController = self.transitionContext!.viewControllerForKey(UITransitionContextFromViewControllerKey) as? CNViewController
        self.fromViewController!.view.frame = self.appearanceTransitioning!.fromViewStartFrameWithContainerFrame(containerFrame)
        self.containerView!.addSubview(self.fromViewController!.view)
        
        // to View Controller
        self.toViewController = self.transitionContext!.viewControllerForKey(UITransitionContextToViewControllerKey) as? CNViewController
        self.toViewController!.view.frame = self.appearanceTransitioning!.toViewStartFrameWithContainerFrame(containerFrame)
        self.containerView!.addSubview(self.toViewController!.view)
    }
    
    func updateinteractiveTransition(percentComplete: CGFloat) -> () {
        let containerFrame = self.containerView!.bounds
        
        // normalization
        var mutatedPercentComplete = percentComplete
        mutatedPercentComplete = max(0.0, mutatedPercentComplete)
        mutatedPercentComplete = min(1.0, mutatedPercentComplete)
        
        self.recentPercentComplete = mutatedPercentComplete
        
        // update fromViewController's frame
        self.fromViewController!.view.frame = CGRect.Transform(self.appearanceTransitioning!.fromViewStartFrameWithContainerFrame(containerFrame),
            finalRect: self.appearanceTransitioning!.fromViewEndFrameWithContainerFrame(containerFrame), rate: self.recentPercentComplete)
        
        // update toViewController's frame
        self.toViewController!.view.frame = CGRect.Transform(self.appearanceTransitioning!.toViewStartFrameWithContainerFrame(containerFrame),
            finalRect: self.appearanceTransitioning!.toViewEndFrameWithContainerFrame(containerFrame), rate: self.recentPercentComplete)
    }
    
    func finishInteractiveTranstion() -> () {
        self.finishInteractiveTransition(true)
    }
    
    func cancelInteractiveTranstion() -> ()  {
        self.finishInteractiveTransition(false)
    }
    
    // MARK: Private methods
    
    private func finishInteractiveTransition(didComplete: Bool) -> () {

        let containerFrame = self.containerView!.bounds
        let transform = self.containerView!.transform
        let duration: NSTimeInterval = NSTimeInterval(self.finishingDuration)
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            
            if didComplete {
                self.fromViewController!.view.frame = self.appearanceTransitioning!.fromViewEndFrameWithContainerFrame(containerFrame)
                self.toViewController!.view.frame = self.appearanceTransitioning!.toViewEndFrameWithContainerFrame(containerFrame)
            } else {
                self.fromViewController!.view.frame = self.appearanceTransitioning!.fromViewStartFrameWithContainerFrame(containerFrame)
                self.toViewController!.view.frame = self.appearanceTransitioning!.toViewStartFrameWithContainerFrame(containerFrame)
            }
            
        }) { (completion: Bool) -> Void in
            
            self.transitionContext!.completeTransition(didComplete)
            self.transitionContext = nil
            self.containerView = nil
            
            if didComplete {
                self.toViewController!.view.transform = transform
                self.toViewController!.view.frame = self.toViewController!.view.superview!.bounds
            } else {
                self.fromViewController!.view.transform = transform
                self.fromViewController!.view.frame = self.fromViewController!.view.superview!.bounds
            }
            
        }
    }

    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.appearanceTransitioning
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.disappearanceTransitioning
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
}
