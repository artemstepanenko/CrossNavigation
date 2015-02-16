//
//  CNTopSegue.swift
//  CrossNavigationDemo
//
//  Created by Nicolas Purita on 12/23/14.
//
//

import UIKit

class CNTopSegue: UIStoryboardSegue {
   
    override func perform() {
        CNSeguePerformer.performSegue(self, direction: .Top)
    }
    
}
