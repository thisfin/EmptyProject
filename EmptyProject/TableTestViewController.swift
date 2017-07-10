//
//  TableTestViewController.swift
//  EmptyProject
//
//  Created by wenyou on 2017/6/16.
//  Copyright © 2017年 fin. All rights reserved.
//

import AppKit
import WYKit
import SnapKit

class TableTestViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    private static let leftSideWidth: CGFloat = 200     // 左边列表宽度
    private static let marginWidth: CGFloat = 20        // 边距
    private static let toolViewHeight: CGFloat = 25     // 工具条高度
    private static let cellHeight: CGFloat = 40

    private let tableViewDragTypeName = "DragTypeName"
    private var datas: [Bean] = {
        var datas = [Bean]()
        for i in 0 ..< 20 {
            datas.append(Bean.init(id: i, name: "name\(i)"))
        }
        return datas
    }()

    private var tableView: NSTableView!
    private var scrollView: NSScrollView!

    override func loadView() { // 代码实现请务必重载此方法添加view
        view = NSView.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.preferredContentSize = AppDelegate.windowSize

        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.colorWithHexValue(0xececec).cgColor
        view.frame = NSRect(origin: NSPoint.zero, size: AppDelegate.windowSize)

        scrollView = ScrollView()
        scrollView.hasVerticalScroller = true
        //        scrollView.borderType = .lineBorder
        scrollView.wantsLayer = true
        scrollView.layer?.masksToBounds = true
        scrollView.layer?.borderWidth = 1
        scrollView.layer?.borderColor = NSColor.colorWithHexValue(0xc8c8c8).cgColor
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }





        tableView = NSTableView(frame: NSRect(origin: NSPoint.zero, size: scrollView.frame.size))
        tableView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = NSColor.colorWithHexValue(0xf5f5f5)
        tableView.headerView = nil
        tableView.register(forDraggedTypes: [tableViewDragTypeName])
        tableView.doubleAction = #selector(TableTestViewController.doubleClicked(_:)) // 双击



        //        tableView.allowsEmptySelection = false

        let column = NSTableColumn(identifier: "column")
        column.isEditable = true
        column.width = tableView.frame.width
        column.resizingMask = .autoresizingMask
        tableView.addTableColumn(column)

        scrollView.contentView.documentView = tableView
        tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
    }

    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return datas.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return datas[row]
    }

    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation { // 拖拽
        return .every
    }

    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool { // 拖
        let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
        pboard.declareTypes([tableViewDragTypeName], owner: self)
        pboard.setData(data, forType: tableViewDragTypeName)
        return true
    }

    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool { // 放
        let pboard = info.draggingPasteboard()
        let rowData = pboard.data(forType: tableViewDragTypeName)
        let rowIndexs: NSIndexSet = NSKeyedUnarchiver.unarchiveObject(with: rowData!) as! NSIndexSet
        let dragRow = rowIndexs.firstIndex

        if datas.count > 1 && dragRow != row { // 数据重新排列
            datas.insert(datas[dragRow], at: row)
            datas.remove(at: dragRow + (dragRow > row ? 1 : 0))
            tableView.noteNumberOfRowsChanged()
            tableView.reloadData()
        }
//        groupEditView.setText(text: nil) // 此处会 deselect, 事件别的地方无法捕获
        return true
    }

    // MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let subView = NSView(frame: NSMakeRect(0, 0, (tableColumn?.width)!, TableTestViewController.cellHeight))
        subView.addSubview({
//            let textField = NSTextField(frame: NSMakeRect(50, 0/*(subView.frame.height - 20) / 2*/, subView.frame.width - 60, 40))
            let textField = NSTextField(frame: subView.frame)
            textField.cell = WYVerticalCenterTextFieldCell.init()
            textField.alignment = NSTextAlignment.justified
            textField.font = NSFont.systemFont(ofSize: 16)
            textField.textColor = NSColor.black
            textField.stringValue = datas[row].name
            textField.isEditable = true
            textField.isBordered = false
            textField.isBezeled = false
            textField.drawsBackground = false
            textField.isSelectable = true
            textField.backgroundColor = NSColor.clear
            return textField
            }())
        return subView
    }

    //    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
    //        let rowView = NSTableRowView(frame: NSRect(x: 0, y: 0, width: 150, height: 50))
    //        rowView.backgroundColor = NSColor.red// row % 2 == 0 ? NSColor.white : NSColor.colorWithHexValue(0xf5f5f5)
    ////        rowView.addSubview({
    ////            let textField = NSTextField(frame: view.frame)
    ////            textField.textColor = NSColor.black
    ////            textField.stringValue = Mock.groups[row].name!
    ////            textField.isEditable = false
    ////            textField.isBordered = false
    ////
    ////            textField.isBezeled = false
    ////            textField.drawsBackground = false
    ////            textField.isSelectable = false
    ////
    ////            //            textField.backgroundColor = NSColor.clear
    ////            return textField
    ////            }())
    //        return rowView
    //    }

    func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) {
        rowView.backgroundColor = row % 2 == 0 ? NSColor.white : NSColor.colorWithHexValue(0xf5f5f5)
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return TableTestViewController.cellHeight
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
//        let row = tableView.selectedRow
//        if row >= 0 && row < datas.count {
//            let content = datas[row].content
//            groupEditView.setText(text: content)
//        } else {
//            groupEditView.setText(text: nil)
//        }
    }
    
    // MARK: - private
    func doubleClicked(_ sender: NSTableView) {
        let row: Int = sender.clickedRow
        NSLog("%ld", row)
    }

    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar.init()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .test
        touchBar.defaultItemIdentifiers = [.only]
//        touchBar.customizationAllowedItemIdentifiers = [, .revert,.button]
        return touchBar
    }
}

class Bean {
    var id: Int
    var name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension TableTestViewController: NSTouchBarDelegate {
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        let custom = NSCustomTouchBarItem.init(identifier: identifier)
        switch identifier {
        case NSTouchBarItemIdentifier.only:
            let label = NSButton.init(title: "save", target: self, action: #selector(WindowController.buttonClicked(_:)))
            custom.view = label
        default:
            ()
        }
        return custom
    }
}

private extension NSTouchBarCustomizationIdentifier {
    static let test = NSTouchBarCustomizationIdentifier.init("onlytest")
}

private extension NSTouchBarItemIdentifier {
    static let only = NSTouchBarItemIdentifier.init("only")
}

