//
//  CNViewController.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/5/14.
//
//

import UIKit

class CNViewController: UIViewController, CNPanGestureHandlerDelegate {
    
    private var nextViewController: CNViewController?
    private var interactiveTransition: CNInteractiveTransition = CNInteractiveTransition()
    private var direction: CNDirection = .None
    private var panGestureHandler: CNPanGestureHandler?
    
    private var _leftID: NSString?
    private var _topID: NSString?
    private var _bottomID: NSString?
    private var _rightID: NSString?
    
    var leftID: NSString? {
        get {
            return _leftID
        }
        
        set(newValue) {
            if self.direction != .Right {
                _leftID = newValue
            }
        }
    }
    
    var rightID: NSString? {
        get {
            return _rightID
        }
        
        set(newValue) {
            if self.direction != .Left {
                _rightID = newValue
            }
        }
    }
    
    var bottomID: NSString? {
        get {
            return _bottomID
        }
        
        set(newValue) {
            if self.direction != .Top {
                _bottomID = newValue
            }
        }
    }
    
    var topID: NSString? {
        get {
            return _topID
        }
        
        set(newValue) {
            if self.direction != .Bottom {
                _topID = newValue
            }
        }
    }
    
    
    override init() {
        super.init()
        
        self.initialize()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializePanGestureRecognizer()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentViewController(viewController: CNViewController, direction: CNDirection, animated: Bool, completion: (() -> ())) {
        if self.isTransitioning() {
            return
        }
        
        viewController.prepareForTransitionToDirection(direction, interactive: false)
        viewController.transitionWillFinishFromViewController(self, toViewController: viewController, recentPercentComplete: 0.0)
        
        self.presentViewController(viewController, animated: animated, completion: completion)
    }
    
    func dismissViewController(animated: Bool, completion: (() -> ())) {
        if self.isTransitioning() {
            return
        }
        
        let previousViewController = self.presentingViewController
        
        if previousViewController is CNViewController {
            self.prepareForBackTransitionInteractive(false)
            self.transitionWillFinishFromViewController(self, toViewController: previousViewController as CNViewController, recentPercentComplete: 0.0)
        }
        
        super.dismissViewControllerAnimated(animated, completion: completion)
    }
    
    // MARK: Private methods
    
    private func initialize() {
        self.transitioningDelegate = self.interactiveTransition
        self.panGestureHandler = CNPanGestureHandler(delegate: self)
    }
    
    private func initializePanGestureRecognizer() {
        let recognizer = UIPanGestureRecognizer(target: self.panGestureHandler!, action: "userDidPan:")
        self.view.addGestureRecognizer(recognizer)
    }
    
    private func isTransitioning() -> Bool {
        return self.isBeingPresented() || self.isBeingDismissed()
    }
    
    private func prepareForTransitionToDirection(direction: CNDirection, interactive: Bool) -> () {

        self.modalPresentationStyle = .FullScreen
        self.direction = direction
        self.interactiveTransition.direction = direction
        self.interactiveTransition.interactive = interactive
    }

    private func prepareForBackTransitionInteractive(interactive: Bool) -> () {
        
        self.nextViewController = self
        self.interactiveTransition.interactive = interactive
        
        // clears previous direction left from cancelled interaction transition
        self.interactiveTransition.direction = interactive ? self.direction.getOpposite() : self.direction
    }
    
    private func transitionWillFinishFromViewController(fromViewController: CNViewController, toViewController: CNViewController, recentPercentComplete: CGFloat) -> () {

        let timeInterval: NSTimeInterval = 0.04    // more than 24 frames per second
        let repeatsCount: UInt = UInt(Double(self.interactiveTransition.finishingDuration) / timeInterval)
        let portion: CGFloat = (1.0 - recentPercentComplete) / CGFloat(repeatsCount)
        
        let timer: CNTimer = CNTimer(timeInterval: timeInterval, repeatCount: repeatsCount, tickCallback: { (index: UInt) -> () in
            
                let percentComplete: CGFloat = recentPercentComplete + portion * CGFloat(index)
            
                fromViewController.viewIsAppearing(1.0 - percentComplete)
                toViewController.viewIsAppearing(percentComplete)
            
            }, stopCallback: { (cancelled) -> () in
                
                fromViewController.viewIsAppearing(0.0)
                toViewController.viewIsAppearing(1.0)
            })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: CNPanGestureHandlerDelegate
    
    func didStartForDirection(sender: CNPanGestureHandler, direction: CNDirection) -> () {
        
        if self.direction.oppositeToDirection(direction) {
            
            self.prepareForBackTransitionInteractive(true)
            self.dismissViewController(true, completion: { () -> () in
                self.nextViewController = nil
            })
            
        } else {
            
            if let storyboardID = self.storyboardIDForPanDirection(direction) {
                
                if let nextViewController: CNViewController? = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardID) as? CNViewController {
                    self.nextViewController = nextViewController
                    
                    self.nextViewController?.prepareForTransitionToDirection(direction, interactive: true)
                    
                    self.presentViewController(self.nextViewController!, animated: true, completion: { () -> Void in
                        self.nextViewController = nil
                    })
                    
                } else {
                    self.nextViewController = nil
                }
            }
        }
    }
    
    func didUpdateWithRatio(sender: CNPanGestureHandler, ratio: CGFloat) -> () {
        
        if self.nextViewController?.interactiveTransition.containerView == nil {
            return
        }
        
        self.nextViewController?.interactiveTransition.updateinteractiveTransition(ratio)
        
        // send events
        if let percentComplete = self.nextViewController?.interactiveTransition.recentPercentComplete {
            self.nextViewController?.interactiveTransition.toViewController?.viewIsAppearing(percentComplete)
            self.nextViewController?.interactiveTransition.fromViewController?.viewIsAppearing(1.0 - percentComplete)
        }
        
    }
    
    func didFinish(sender: CNPanGestureHandler) -> () {

        if let interactiveTransition = self.nextViewController?.interactiveTransition {

            interactiveTransition.finishInteractiveTranstion()
            
            self.nextViewController?.transitionWillFinishFromViewController(interactiveTransition.fromViewController!, toViewController: interactiveTransition.toViewController!, recentPercentComplete: interactiveTransition.recentPercentComplete)
        }
        
    }
    
    func didCancel(sender: CNPanGestureHandler) -> () {
        if let interactiveTransition = self.nextViewController?.interactiveTransition {
            
            interactiveTransition.cancelInteractiveTranstion()
            
            self.nextViewController?.transitionWillFinishFromViewController(interactiveTransition.toViewController!, toViewController: interactiveTransition.fromViewController!, recentPercentComplete: (1.0 - interactiveTransition.recentPercentComplete))
        }
    }
    
    // MARK: Event
    
    func viewIsAppearing(percent: CGFloat) -> () {
        // default implementation does nothing
    }
    
    func shouldAutotransitToDirection(direction: CNDirection, present: Bool) -> Bool {
        return true
    }
    
    // Helpers
    func directionForOffset(sender: CNPanGestureHandler, offset: CGPoint) -> CNDirection {

        if self.isTransitioning() {
            return .None
        }
        
        var direction: CNDirection = .None
        let backDirection: CNDirection = self.direction.getOpposite()
        
        if fabs(offset.x) >= fabs(offset.y) {
            
            if offset.x < 0 {
                direction = (backDirection == .Right || self.rightID != nil) ? .Right : .None
            } else {
                direction = (backDirection == .Left || self.leftID != nil) ? .Left : .None
            }
            
        } else {
            
            if offset.y < 0 {
                direction = (backDirection == .Bottom || self.bottomID != nil) ? .Bottom : .None
            } else {
                direction = (backDirection == .Top || self.topID != nil) ? .Top : .None
            }
            
        }
        
        if direction != .None {
            return self.shouldAutotransitToDirection(direction, present:!(direction == backDirection)) ? direction : .None
        }
        
        return .None
        
    }
    
    func locationOfGesture(sender: CNPanGestureHandler, gestureRecognizer: UIPanGestureRecognizer) -> CGPoint {

        let view: UIView = self.nextViewController?.interactiveTransition.containerView ?? self.view
        
        return gestureRecognizer.locationInView(view)
    }
    
    func viewSizeForPanGestureHandler(sender: CNPanGestureHandler) -> CGSize {
        
        let view: UIView = self.nextViewController?.interactiveTransition.containerView ?? self.view
        
        return view.bounds.size
    }
    
    func storyboardIDForPanDirection(direction: CNDirection) -> NSString? {
        
        switch(direction) {
        case .Right:
            return self.rightID
        case .Left:
            return self.leftID
        case .Top:
            return self.topID
        case .Bottom:
            return self.bottomID
        default:
            return nil
            
        }
        
    }

}
