//
//  AppDelegate.swift
//  EmptyProject
//
//  Created by fin on 2017/6/1.
//  Copyright © 2017年 fin. All rights reserved.
//

import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    static let windowSize = NSMakeSize(800, 500)
    var window: NSWindow!
    var windowController: NSWindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if #available(OSX 10.12.2, *) {
            NSApp.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }

        window = TextWindow(contentRect: NSRect.zero,
                            styleMask: [.closable, .resizable, .miniaturizable, .titled],
                            backing: .buffered,
                            defer: false)

        // 互相持有
        windowController = WindowController.init(window: window)
        window.windowController = windowController
        window.center()
        window.makeKeyAndOrderFront(self)

//        DidSetTest().test()

    }
}
