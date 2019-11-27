//
//  SnippetViewController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/15.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa
import Preferences

fileprivate class InnerItem: NSObject {
    @objc dynamic var item: String
    
    init(_ item: String) {
        self.item = item
        
        super.init()
    }
}

class SnippetsViewController: NSViewController, PreferencePane {
    var preferencePaneIdentifier: Identifier = .snippet
    var preferencePaneTitle: String = "Snippet"
    var toolbarItemIcon: NSImage = #imageLiteral(resourceName: "toolbar_snippet")
    override var preferredContentSize: NSSize {
        get { NSSize(width: 640, height: 480) }
        set {}
    }
    
    @objc dynamic var managedContext = StoreService.shared.managedContext
    @objc dynamic var selectedObject: SnippetMO?
    @objc dynamic let sortDescriptor = Constants.genSortDescriptor(true)
    
    @IBOutlet weak var snippetsContextMenu: NSMenu!
    @IBOutlet weak var snippetDataController: NSArrayController!
    @IBOutlet weak var snippetContentEditor: NSTextView!
    @IBOutlet weak var snippetTable: NSTableView!
    @IBOutlet weak var helperPopover: NSPopover!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        snippetContentEditor.font = .systemFont(ofSize: 14)
    }
    
    override func viewWillDisappear() {
        if let snippets = snippetDataController.arrangedObjects as? [SnippetMO] {
            let index = snippetDataController.selectionIndex

            if index >= 0 && index < snippets.count {
                snippets[snippetDataController.selectionIndex].content = snippetContentEditor.string.data(using: .utf8)
            }
        }
        
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch {
            LoggingService.shared.error("Faile to save data: \(error)")
        }
    }
    
    @IBAction func addSnippet(_ sender: Any) {
        
    }
    
    @IBAction func showHelper(_ sender: NSButton) {
        helperPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
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
