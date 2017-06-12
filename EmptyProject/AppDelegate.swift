//
//  AppDelegate.swift
//  EmptyProject
//
//  Created by fin on 2017/6/1.
//  Copyright © 2017年 fin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    static let windowSize = NSMakeSize(800, 500)
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = TextWindow(contentRect: NSRect.zero,
                            styleMask: [.closable, .resizable, .miniaturizable, .titled],
                            backing: .buffered,
                            defer: false)
        window.center()
        window.makeKeyAndOrderFront(self)

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
