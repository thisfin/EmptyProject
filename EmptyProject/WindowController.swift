//
//  WindowController.swift
//  EmptyProject
//
//  Created by wenyou on 2017/6/21.
//  Copyright © 2017年 fin. All rights reserved.
//

import AppKit

class WindowController: NSWindowController {
    var identifiers: [NSTouchBarItemIdentifier] = [ .segment, .save, .scrubber]
    var a = 1

    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar.init()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .test
//        touchBar.defaultItemIdentifiers = [.save, .revert, .flexibleSpace, .button]
        touchBar.defaultItemIdentifiers = identifiers
        touchBar.customizationAllowedItemIdentifiers = [.save, .revert,.button]
        return touchBar
    }

    @available(OSX 10.12.2, *)
    func buttonClicked(_ sender: NSButton) {
        NSLog("clicked")

        identifiers = [.segment, .fixedSpaceLarge, .save]
        self.touchBar = nil
    }

    // MARK: - NSScrubberDataSource
//    @available(OSX 10.12.2, *)
//    public func numberOfItems(for scrubber: NSScrubber) -> Int {
//        return 10
//    }
//
//    @available(OSX 10.12.2, *)
//    public func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
//        let view = NSScrubberTextItemView.init()
//        view.title = "num:\(index)  "
//        return view
//    }

    // MARK: - NSScrubberDelegate

    func getString(index: Int) -> String {
        return "num:\(index)"
    }
}

extension WindowController: NSTouchBarDelegate {
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        let custom = NSCustomTouchBarItem.init(identifier: identifier)
        switch identifier {
        case NSTouchBarItemIdentifier.save:
            let label = NSButton.init(title: "save", target: self, action: #selector(WindowController.buttonClicked(_:)))
            custom.view = label

        case NSTouchBarItemIdentifier.revert:
            let label = NSButton.init(title: "revert", target: self, action: #selector(WindowController.buttonClicked(_:)))
            custom.view = label

        case NSTouchBarItemIdentifier.button:
            let button = NSButton.init(title: "buttonbuttonbuttonbutton", target: self, action: #selector(WindowController.buttonClicked(_:)))
            button.state = NSOnState
            button.bezelColor = NSColor.red
            //            button.isHighlighted = true
            custom.view = button

        case NSTouchBarItemIdentifier.segment:
            let segment = NSSegmentedControl.init(labels: ["a", "b", "c"], trackingMode: .selectOne, target: self, action: #selector(WindowController.buttonClicked(_:)))
            custom.view = segment
        case NSTouchBarItemIdentifier.scrubber:
            let scrubber = NSScrubber()
            //            scrubber.scrubberLayout = NSScrubberFlowLayout()
            scrubber.scrubberLayout = NSScrubberProportionalLayout()
            scrubber.register(NSScrubberTextItemView.self, forItemIdentifier: "RatingScrubberItemIdentifier")
            scrubber.mode = .fixed
            scrubber.selectionBackgroundStyle = .roundedBackground
            scrubber.delegate = self
            scrubber.dataSource = self
            custom.view = scrubber
        //            scrubber.bind("selectedIndex", to: self, withKeyPath: #keyPath(rating), options: nil)
        default:
            ()
        }
        return custom
    }
}

extension WindowController: NSScrubberDataSource {
    @available(OSX 10.12.2, *)
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        return 10
    }

    @available(OSX 10.12.2, *)
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        let view = NSScrubberTextItemView.init()
        view.title = getString(index: index)
        return view
    }
}

extension WindowController: NSScrubberDelegate {

}

extension WindowController: NSScrubberFlowLayoutDelegate {
    @available(OSX 10.12.2, *)
    func scrubber(_ scrubber: NSScrubber, layout: NSScrubberFlowLayout, sizeForItemAt itemIndex: Int) -> NSSize {
        let label = NSTextField.init(string: getString(index: itemIndex))
        return NSMakeSize(label.fittingSize.width, 30)
    }
}

private extension NSTouchBarCustomizationIdentifier {
    static let test = NSTouchBarCustomizationIdentifier.init("test")
}

private extension NSTouchBarItemIdentifier {
    static let save = NSTouchBarItemIdentifier.init("save")
    static let revert = NSTouchBarItemIdentifier.init("revert")
    static let button = NSTouchBarItemIdentifier.init("button")
    static let segment = NSTouchBarItemIdentifier.init("segment")
    static let scrubber = NSTouchBarItemIdentifier.init("scrubber")
}
