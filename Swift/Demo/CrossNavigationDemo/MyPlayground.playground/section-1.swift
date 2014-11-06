// Playground - noun: a place where people can play

import UIKit

class A {
    class func foo() -> Void {
        println("A")
    }
    
    func bar() -> Void {
        self.
    }
}

class B : A {
    override class func foo() -> Void {
        println("B")
    }
}

class C : A {
    override class func foo() -> Void {
        println("C")
    }
}


B.foo()
A.foo()
C.foo()