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

fileprivate class CustomTableRowView: NSTableRowView {
    override func drawSelection(in dirtyRect: NSRect) {
        
        let selectionRect = NSInsetRect(self.bounds, 0, 0)
        NSColor(red: 0, green: 0.4797514081, blue: 0.998437345, alpha: 1).setStroke()
        NSColor(red: 0, green: 0.4797514081, blue: 0.998437345, alpha: 0.2).setFill()
        let selectionPath = NSBezierPath.init(rect: selectionRect)
        selectionPath.fill()
        selectionPath.stroke()
    }
}

// MARK: view controller
class SearchViewController: NSViewController {
    let filterTemplate = NSPredicate(format: "content LIKE $KEYWORD")
    
    @objc dynamic lazy var managedContext: NSManagedObjectContext = {
        ClipBoardService.managedContext
    }()
    
    @objc dynamic var dataFilter: NSPredicate?
    @objc dynamic var sortDescripter = [NSSortDescriptor]()
    @objc dynamic var selected: SelectedItem = .empty
    @objc dynamic var dataCount = 0
    @objc dynamic var isDataListEmpty: Bool {
        get { dataCount == 0 }
    }
    
    @IBOutlet var searchField: NSTextField!
    @IBOutlet var imgButton: NSButton!
    @IBOutlet var resultListView: NSTableView!
    @IBOutlet var visualEffectView: NSVisualEffectView!
    @IBOutlet weak var dataListController: NSArrayController!
    
    @IBOutlet var containerWindow: NSWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitorArrowEvent()
        
        let dateSorter = NSSortDescriptor(key: "time", ascending: true) { (rawLHS, rawRHS) -> ComparisonResult in
            guard let lhs = rawLHS as? Date, let rhs = rawRHS as? Date else { return .orderedSame }
            
            return (lhs > rhs) ? .orderedAscending : .orderedDescending
        }
        
        sortDescripter.append(dateSorter)
        resultListView.backgroundColor = .clear
        searchField.isBezeled = false
        searchField.focusRingType = .none
        searchField.font = NSFont.systemFont(ofSize: 28, weight: .light)
        view.window?.standardWindowButton(.zoomButton)?.isHidden = true
        view.window?.standardWindowButton(.closeButton)?.isHidden = true
        view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        
        // register handler for core data reload event
        NotificationCenter.default.addObserver(forName: .ShouldReloadCoreData, object: nil, queue: nil) { (notice) in
            
            self.dataListController.fetch(self)
            self.selected = .empty
        }
    }
    
    override func viewWillAppear() {
        searchField.becomeFirstResponder()
    }
    
    override func awakeFromNib() {
        dataListController.addObserver(self, forKeyPath: "arrangedObjects", options: [.new], context: nil)
        checkDataListCount()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "arrangedObjects":
            checkDataListCount()
        default:
            break
        }
    }
    
    func monitorArrowEvent() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            switch $0.keyCode {
            // [arrow down]: 125, [arrow up]: 126
            case 125, 126:
                self.resultListView.keyDown(with: $0)
                return nil
            // [l]: 37
            case 37:
                if $0.modifierFlags.contains(.command) {
                    self.searchField.becomeFirstResponder()
                    return nil
                }
                return $0
            // [Enter]: 36
            case 36:
                // specify paste type
                if $0.modifierFlags.contains(.command) {
                    
                } else {
                    ClipBoardService.paste()
                }
                self.containerWindow.close()
                return nil
            // [Escape key]: 53
            case 53:
                self.containerWindow.close()
                return nil
            default:
                return $0
            }
        }
    }
    
    func checkDataListCount() {
        guard let items = dataListController.arrangedObjects as? [Any] else { return }
        willChangeValue(forKey: "isDataListEmpty")
        dataCount = items.count
        didChangeValue(forKey: "isDataListEmpty")
    }
}

// MARK: Text Delegate
extension SearchViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let controlField = obj.object as? NSTextField else { return }
        self.dataFilter = filterTemplate.withSubstitutionVariables(["KEYWORD": "*\(controlField.stringValue)*"])
    }
}

// MARK: Table Delegate
extension SearchViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard dataListController.selectedObjects.count > 0 else {
            selected = .empty
            return
        }
        guard let item = dataListController.selectedObjects[0] as? PBItem else { return }
        selected = .init(title: item.time.description, item.content)
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return CustomTableRowView()
    }
}

// MARK: Nested Type
extension SearchViewController {
    class SelectedItem: NSObject {
        @objc dynamic var title: String
        @objc dynamic var content: String
        
        static let empty = SelectedItem(title: "", "")
        
        init(title: String, _ content: String) {
            self.title = title
            self.content = content
        }
    }
}
