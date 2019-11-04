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
    
    @objc dynamic var managedContext = StoreService.shared.managedContext
    @objc dynamic var selectedObject: SnippetMO?
    
    @IBOutlet weak var snippetsContextMenu: NSMenu!
    @IBOutlet weak var snippetDataController: NSArrayController!
    @IBOutlet weak var snippetContentEditor: NSTextView!
    @IBOutlet weak var snippetTable: NSTableView!
    @IBOutlet var helperPopover: NSPopover!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        snippetContentEditor.font = .systemFont(ofSize: 16)
    }
    
    override func viewWillDisappear() {
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

extension SnippetsViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard snippetDataController.selectedObjects.count > 0 else { return }
        guard let item = snippetDataController.selectedObjects[0] as? SnippetMO else { return }
        
        selectedObject = item
    }
}

extension SnippetsViewController: NSTextViewDelegate {    
    func textDidChange(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else { return }
        selectedObject?.content = textView.string
    }
}
