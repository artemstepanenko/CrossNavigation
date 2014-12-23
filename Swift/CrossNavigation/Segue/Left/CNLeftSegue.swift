//
//  CNLeftSegue.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 12/23/14.
//
//

import UIKit

class CNLeftSegue: UIStoryboardSegue {
   
    override func perform() {
        CNSeguePerformer.performSegue(self, direction: .Left)
    }
    
}
