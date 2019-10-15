//
//  SearchViewController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/11.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class CPCellView: NSTableCellView {
    @IBOutlet var content: NSTextField!
    @IBOutlet var time: NSTextField!
}

class SearchViewController: NSViewController {
    fileprivate var searchResult = [ClipBoardItem]()
    
    @IBOutlet var searchField: NSTextField!
    @IBOutlet var imgButton: NSButton!
    @IBOutlet var outerStack: NSStackView!
    @IBOutlet var resultList: NSTableView!
    @IBOutlet var visualEffectView: NSVisualEffectView!
    
    @IBOutlet var containerWindow: NSWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        searchField.isBezeled = false
//        searchField.drawsBackground = false
        searchField.focusRingType = .none
        searchField.font = NSFont.systemFont(ofSize: 28, weight: .light)
        view.window?.standardWindowButton(.zoomButton)?.isHidden = true
        view.window?.standardWindowButton(.closeButton)?.isHidden = true
        view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
    }
    
    override func awakeFromNib() {
//        outerStack.addArrangedSubview(resultList)
//        updateContentSize()
    }
    
    func updateContentSize() {
        let viewCurrentSize = view.bounds.size
        let viewCurrentOrigin = view.window!.frame.origin
        
        let newFrameSize = NSSize(width: viewCurrentSize.width, height: viewCurrentSize.height + resultList.bounds.size.height)
        let newOrigin = NSPoint(x: viewCurrentOrigin.x, y: viewCurrentOrigin.y + viewCurrentSize.height - newFrameSize.height)
        let newFrame = NSRect(origin: newOrigin, size: newFrameSize)
        view.setFrameSize(newFrameSize)
        view.window?.setFrame(newFrame, display: true)
    }
    
    // override to avoid
    override func keyDown(with event: NSEvent) {
        
    }
}

extension SearchViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let controlField = obj.object as? NSTextField else { return }
        print(controlField.stringValue)
    }
}

extension SearchViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }
}

extension SearchViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cellView = tableView.makeView(withIdentifier: .init("CPCellView"), owner: containerWindow.windowController) else {  return nil }
        
        guard let cpCellView = cellView as? CPCellView else { return nil }
        let data = ClipBoardItem("lalalafa")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cpCellView.content.stringValue = data.content
        cpCellView.time.stringValue = dateFormatter.string(from: data.time)
        
        return cpCellView
    }
}
