//
//  SearchViewController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/11.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class SearchViewController: NSViewController {

    @IBOutlet var searchField: NSTextField!
    @IBOutlet var imgButton: NSButton!
    @IBOutlet var outerStack: NSStackView!
    @IBOutlet var resultList: NSScrollView!
    
    override func viewDidLoad() {
        print("search view loaded")
        super.viewDidLoad()
        searchField.isBezeled = false
        searchField.drawsBackground = false
        searchField.focusRingType = .none
        searchField.font = NSFont.systemFont(ofSize: 28, weight: .light)
//        view.setFrameSize(CGSize(width: 480, height: 200))
        // Do view setup here.
    }
    
    override func awakeFromNib() {
        outerStack.addArrangedSubview(resultList)
        
    }
    
}

extension SearchViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        print("outline delegate called")
        
        return NSTextField(labelWithString: item as! String)
    }
}

extension SearchViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        print("called")
        return 2
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        print("child data")
        return "lalala"
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 48
    }
}
