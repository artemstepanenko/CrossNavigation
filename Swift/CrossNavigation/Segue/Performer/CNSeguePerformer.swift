//
//  CNSeguePerformer.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 12/23/14.
//
//

import UIKit

class CNSeguePerformer: NSObject {

    class func performSegue(segue: UIStoryboardSegue, direction: CNDirection) -> () {
        
        assert(segue.sourceViewController is CNViewController,  "Source view controller must be CNViewController")
        assert(segue.destinationViewController is CNViewController,  "Destination view controller must be CNViewController")

        let source: CNViewController = segue.sourceViewController as CNViewController
        let destination: CNViewController = segue.destinationViewController as CNViewController
        
        
        source.presentViewController(destination, direction: direction, animated: true) { () -> () in
            
        }
        
    }
    
}
