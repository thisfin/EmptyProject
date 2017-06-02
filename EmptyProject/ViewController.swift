//
//  ViewController.swift
//  Authorization
//
//  Created by wenyou on 2017/4/19.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer?.backgroundColor = NSColor.white.cgColor
        view.frame = NSRect(origin: .zero, size: AppDelegate.windowSize)
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        view.addSubview({
            let button = NSButton.init(title: "test", target: self, action: #selector(ViewController.buttonClicked(_:)))
            button.frame.origin = .zero

            return button
            }())



    }

    func buttonClicked(_ sender: NSButton) {

        var dict: NSDictionary?
        //        let appleScript = NSAppleScript.init(source: "tell application \"Terminal\"\ndo script \"sudo /bin/chmod +a \\\"user:fin:allow write\\\" /etc/host1\"\nend tell")
                let appleScript = NSAppleScript.init(source: "tell application \"Terminal\"\ndo script\nend tell")
//        let appleScript = NSAppleScript.init(source: "tell application \"Terminal\"\nactivate\nend tell")
        appleScript?.executeAndReturnError(&dict)
        NSLog("\(String(describing: dict))")
    }
}
 
