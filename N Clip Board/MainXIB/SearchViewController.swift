//
//  SearchViewController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/11.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class SearchViewController: NSViewController {
    fileprivate var searchValue = ""
    @objc dynamic var searchFieldValue: String {
        get {
            return searchValue
        }
        set {
            print(newValue)
            searchValue = newValue
        }
    }
    
    @IBOutlet var searchField: NSTextField!
    @IBOutlet var imgButton: NSButton!
    @IBOutlet var outerStack: NSStackView!
    @IBOutlet var resultList: NSScrollView!
    @IBOutlet var visualEffectView: NSVisualEffectView!
    @IBOutlet var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        searchField.isBezeled = false
        searchField.drawsBackground = false
        searchField.focusRingType = .none
        searchField.font = NSFont.systemFont(ofSize: 28, weight: .light)
        resultList.drawsBackground = false
        view.window?.standardWindowButton(.zoomButton)?.isHidden = true
        view.window?.standardWindowButton(.closeButton)?.isHidden = true
        view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
    }
    
    override func awakeFromNib() {
        outlineView.backgroundColor = .clear
        outerStack.addArrangedSubview(resultList)
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
    
    override func keyDown(with event: NSEvent) {
        
    }
}

extension SearchViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let controlField = obj.object as? NSTextField else { return }
        print(controlField.stringValue)
    }
}

extension SearchViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        return NSTextField(labelWithString: item as! String)
    }
}

extension SearchViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return 20
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return "lalala"
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 48
    }
}
