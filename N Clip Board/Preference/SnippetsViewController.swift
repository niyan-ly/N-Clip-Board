//
//  SnippetViewController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/15.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

fileprivate class InnerItem: NSObject {
    @objc dynamic var item: String
    
    init(_ item: String) {
        self.item = item
        
        super.init()
    }
}

class SnippetsViewController: NSViewController, ViewInitialSize {
    var initialSize: CGSize = CGSize(width: 640, height: 480)
    
    @IBOutlet weak var snippetsContextMenu: NSMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func popupSnippetsContextMenu(_ sender: NSButton) {
        NSMenu.popUpContextMenu(snippetsContextMenu, with: NSApp.currentEvent!, for: view)
    }
    
    @IBAction func exportSnippets(_ sender: Any) {
        print("export")
    }
    
    @IBAction func importSnippets(_ sender: Any) {
        print("import")
    }
}

extension SnippetsViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return "data for: \(row)"
    }
}
