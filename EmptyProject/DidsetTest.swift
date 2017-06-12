//
//  DidsetTest.swift
//  EmptyProject
//
//  Created by wenyou on 2017/6/12.
//  Copyright © 2017年 fin. All rights reserved.
//

import Foundation

class DidSetTest {
    func test() {
        a.aa = "1"
        a.aa = "2"

        a = A()

        b.bb = "1"
        b.bb = "2"

        b = B()
    }

    var a: A = {
        let temp = A()
        return temp
        }() {
        didSet {
            NSLog("a didset")
        }
    }

    var b: B = {
        let temp = B()
        return temp
        }() {
        didSet {
            NSLog("b didset")
        }
    }
}

class A {
    var aa: String?
}

struct B {
    var bb: String?
}
