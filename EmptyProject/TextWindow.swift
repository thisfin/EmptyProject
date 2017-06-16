//
//  TextWindow.swift
//  RichTextView
//
//  Created by wenyou on 2017/3/20.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import AppKit

class TextWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindowStyleMask, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: bufferingType, defer: flag)

        self.minSize = NSMakeSize(AppDelegate.windowSize.width, AppDelegate.windowSize.height + 22) // 22 是标题栏的高度
//        contentViewController = ViewController()
        contentViewController = TableTestViewController()
        title = "TextView Example"
    }
}
