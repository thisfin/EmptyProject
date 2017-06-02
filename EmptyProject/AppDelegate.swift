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

//        var dict: NSDictionary?
////        let appleScript = NSAppleScript.init(source: "tell application \"Terminal\"\ndo script \"sudo /bin/chmod +a \\\"user:fin:allow write\\\" /etc/host1\"\nend tell")
////        let appleScript = NSAppleScript.init(source: "tell application \"Terminal\"\ndo script\nend tell")
//        let appleScript = NSAppleScript.init(source: "tell application \"Terminal\"\nactivate\nend tell")
//        appleScript?.executeAndReturnError(&dict)
//        NSLog("\(String(describing: dict))")
    }
}
