//
//  CNTimer.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 11/5/14.
//
//

import UIKit

typealias CNTimerDidStick = (index: UInt) -> ()
typealias CNTimerDidStop = (cancelled: Bool) -> ()

class CNTimer : NSObject {
 
    private var timer: NSTimer?
    private var ticksCounter: UInt = 0
    private var maxTicksCount: UInt = 0
    private var currentTickCallback: CNTimerDidStick?
    private var currentStopCallback: CNTimerDidStop?
    
    // Public methods
    
    init(timeInterval: NSTimeInterval, repeatCount: UInt, tickCallback: CNTimerDidStick, stopCallback: CNTimerDidStop) {
        super.init()
        
        self.maxTicksCount = repeatCount
        self.currentTickCallback = tickCallback
        self.currentStopCallback = stopCallback
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "timerDidTick", userInfo: nil, repeats: true)
        
    }
    
    func isStarted() -> Bool {
        return self.timer != nil
    }
    
    func cancel() -> () {
        self.stop(true)
    }
    
    // Private methods
    
    private func timerDidTick() -> () {
        if self.currentTickCallback != nil {
            self.currentTickCallback!(index: self.ticksCounter)
        }
        
        self.ticksCounter++
        
        if self.maxTicksCount > 0 && self.ticksCounter >= self.maxTicksCount {
            self.stop(false)
        }
    }
    
    private func stop(cancelled: Bool) -> () {
        self.releaseTimer()
        self.ticksCounter = 0
        
        if self.currentStopCallback != nil {
            self.currentStopCallback!(cancelled: cancelled)
        }
        
        self.currentStopCallback = nil
        self.currentTickCallback = nil
    }
    
    private func releaseTimer() -> (){
        if self.timer != nil {
            if self.timer!.valid {
                self.timer?.invalidate()
            }
            
            self.timer = nil
        }
    }
}
