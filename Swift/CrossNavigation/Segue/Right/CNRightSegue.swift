//
//  CNRightSegue.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 12/23/14.
//
//

import UIKit

class CNRightSegue: UIStoryboardSegue {
   
    override func perform() {
        CNSeguePerformer.performSegue(self, direction: .Right)
    }
    
}
