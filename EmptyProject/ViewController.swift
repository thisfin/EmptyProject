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

        view.wantsLayer = true
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
        let url = URL.init(fileURLWithPath: NSOpenStepRootDirectory() + "etc/hosts")
        let isReadable = FileManager.default.isReadableFile(atPath: url.path)
        let isWritable = FileManager.default.isWritableFile(atPath: url.path)
//        let isWritable = FileManager.default.fileExists(atPath: url.path)
        let dict = try! FileManager.default.attributesOfItem(atPath: url.path)
        let dic = try! FileManager.default.attributesOfFileSystem(forPath: url.path)

        let fileContent = try! String.init(contentsOfFile: url.path, encoding: .utf8)
        NSLog(fileContent)

        let alert = NSAlert.init()
        alert.messageText = "提示"
        alert.informativeText = "你" + (isWritable ? "有" : "无") + " /etc/hosts 文件的权限"
        alert.alertStyle = .critical
        alert.addButton(withTitle: "cancel")
        alert.addButton(withTitle: isWritable ? "消权" : "加权")
        let response = alert.runModal()
        switch response {
        case NSAlertSecondButtonReturn:
            var error: NSDictionary?
            let ope = isWritable ? "-" : "+"
            var cmd = ""
            cmd += "tell application \"Terminal\"\n"
            cmd += "activate (do script \"sudo /bin/chmod \(ope)a \\\"user:\(NSUserName()):allow write\\\" /etc/hosts\")\n"
            cmd += "end tell"
            let appleScript = NSAppleScript.init(source: cmd)
            appleScript?.executeAndReturnError(&error)
            NSLog("\(String(describing: error))")
        default:
            ()
        }
    }
}
