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
    @IBOutlet var icon: NSButton!
}

fileprivate class CustomTableRowView: NSTableRowView {
    override func drawSelection(in dirtyRect: NSRect) {
        
        let selectionRect = NSInsetRect(self.bounds, 0, 0)
//        NSColor(red: 0, green: 0.4797514081, blue: 0.998437345, alpha: 1).setStroke()
//        NSColor(red: 0, green: 0.4797514081, blue: 0.998437345, alpha: 0.2).setFill()
        NSColor.systemBlue.setFill()
        let selectionPath = NSBezierPath.init(rect: selectionRect)
        selectionPath.fill()
        selectionPath.stroke()
    }
}

// MARK: view controller
class SearchViewController: NSViewController {
    let filterTemplate = NSPredicate(format: "($CONTENT LIKE[cd] $KEYWORD || label LIKE[c] $KEYWORD) AND entityType IN $ENTITY_TYPE_GROUP")
    var viewType: SearchPanelViewType = .All
    
    @objc dynamic var managedContext: NSManagedObjectContext {
        get { StoreService.shared.managedContext }
    }
    
    @objc dynamic var dataFilter: NSPredicate?
    @objc dynamic var sortDescripter = [NSSortDescriptor]()
    @objc dynamic var selected: LabeledMO?
    @objc dynamic var dataCount: Int {
        get {
            (dataListController.arrangedObjects as? [Any])?.count ?? 0
        }
    }
    @objc dynamic var isDataListEmpty: Bool {
        get { dataCount == 0 }
    }
    
    @IBOutlet weak var viewTrigger: NSButton!
    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var resultListView: NSTableView!
    @IBOutlet weak var detailView: NSView!
    @IBOutlet weak var masterView: NSView!
    @IBOutlet weak var dataListController: SearchViewArrayController!
    @IBOutlet weak var contentView: NSView!
    
    @IBOutlet var containerWindow: NSWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitorArrowEvent()
        updateViewTypeTriggerStyle()
        
        viewTrigger.toolTip = "Show All Content"
        
        let dateSorter = NSSortDescriptor(key: "createdAt", ascending: true) { (rawLHS, rawRHS) -> ComparisonResult in
            guard let lhs = rawLHS as? Date, let rhs = rawRHS as? Date else { return .orderedSame }

            return (lhs > rhs) ? .orderedAscending : .orderedDescending
        }

        sortDescripter.append(dateSorter)
//        resultListView.backgroundColor = .clear
        searchField.isBezeled = false
        searchField.focusRingType = .none
        searchField.font = NSFont.systemFont(ofSize: 28, weight: .light)
        view.window?.standardWindowButton(.zoomButton)?.isHidden = true
        view.window?.standardWindowButton(.closeButton)?.isHidden = true
        view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        
        // register handler for core data reload event
        NotificationCenter.default.addObserver(forName: .ShouldReloadCoreData, object: nil, queue: nil) { (notice) in

            self.dataListController.fetch(self)
        }
    }
    
    override func viewWillAppear() {
        searchField.becomeFirstResponder()
        resultListView.selectRowIndexes(.init(integer: 0), byExtendingSelection: false)
        resultListView.scrollRowToVisible(0)
    }
    
    override func awakeFromNib() {
        dataListController.addObserver(self, forKeyPath: "arrangedObjects", options: [.new], context: nil)
        dataListController.addObserver(self, forKeyPath: "selectionIndex", options: [.new], context: nil)
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: nil, queue: nil) { (notice) in
            self.resultListView.reloadData()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "arrangedObjects":
            willChangeValue(forKey: "dataCount")
            didChangeValue(forKey: "dataCount")
        case "selectionIndex":
            if let items = dataListController.arrangedObjects as? [LabeledMO] {
                if items.count > dataListController.selectionIndex {
                    selected = items[dataListController.selectionIndex]

                    return
                }
            }
            
            selected = nil
        default:
            break
        }
    }
    
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        switch key {
        case "isDataListEmpty":
            return [#keyPath(dataCount)]
        default:
            return []
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
//                if self.selected == .empty {
//                    return nil
//                }
//                // specify paste type
//                if $0.modifierFlags.contains(.command) {
//
//                } else {
//                    // ClipBoardService.shared.write(content: self.selected.content)
//                    ClipBoardService.shared.paste()
//                }
//                self.containerWindow.close()
                return nil
            // [Escape key]: 53
            case 53:
                self.containerWindow.close()
                return nil
            default:
                return $0
            }
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) {
            switch $0.keyCode {
            // [Tab key]: 48
            case 48:
                if $0.modifierFlags.description == "⌃" {
                    self.nextView(self)
                }
                return nil
            default:
                return $0
            }
        }
    }
    
    @IBAction func nextView(_ sender: Any) {
        if viewType.rawValue < 2 {
            viewType = SearchPanelViewType(rawValue: viewType.rawValue + 1)!
        } else {
            viewType = .All
        }
        
        updateViewTypeTriggerStyle()
    }
    
    func updateViewTypeTriggerStyle() {
        
        switch viewType {
        case .ClipBoard:
            viewTrigger.image = .init(imageLiteralResourceName: "ClipBoard")
            viewTrigger.toolTip = "Show ClipBoard Content"
        case .All:
            viewTrigger.image = .init(imageLiteralResourceName: "All")
            viewTrigger.toolTip = "Show All Content"
        case .Snippet:
            viewTrigger.image = .init(imageLiteralResourceName: "Snippet")
            viewTrigger.toolTip = "Show Snippet"
        }

        updateSearchPredicate()
    }
    
    func updateSearchPredicate() {
        let entityTypeMapper: Dictionary<Int, [String]> = [
            0: ["PBItem", "Snippet"],
            1: ["PBItem"],
            2: ["Snippet"]
        ]
    
        dataFilter = filterTemplate.withSubstitutionVariables([
            "KEYWORD": "*\(searchField.stringValue)*",
            "ENTITY_TYPE_GROUP": entityTypeMapper[viewType.rawValue] ?? entityTypeMapper[0]!
        ])
    }
}

// MARK: Text Delegate
extension SearchViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        updateSearchPredicate()
    }
}

// MARK: Table Delegate
extension SearchViewController: NSTableViewDelegate {
    func tryToSelectFirst() {
        guard let labeld = dataListController.arrangedObjects as? [LabeledMO] else {
            LoggingService.shared.warn("fail to cast arrangedObjects of NSArrayController into ManagedObject")
            return
        }
        
        if labeld.count > 0 {
            resultListView.selectRowIndexes(.init(integer: 0), byExtendingSelection: false)
        } else {
//            selected = nil
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard dataListController.selectedObjects.count > 0 else {
            tryToSelectFirst()
            return
        }
        guard let item = dataListController.selectedObjects[0] as? LabeledMO else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        selected = .init(title: dateFormatter.string(from: item.createdAt), item.content)
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return CustomTableRowView()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let view = tableView.makeView(withIdentifier: .init("CPCellView"), owner: containerWindow.windowController) as? CPCellView else { return nil }
        
        guard let labeledList = dataListController.arrangedObjects as? [LabeledMO] else { return nil }
        
        let entityType = labeledList[row].entityType
        
        if entityType == "PBItem" {
            let item = labeledList[row] as! PBItemMO
            switch NSPasteboard.PasteboardType(item.contentType) {
            case .string:
                view.content.stringValue = String(data: item.content!, encoding: .utf8) ?? ""
            default:
                view.content.stringValue = ""
            }
            if let identifier = item.bundleIdentifier {
                view.icon.image = Utility.findAppIcon(by: identifier)
            } else {
                view.icon.image = NSImage(named: .init("NSApplicationIcon"))
            }
        } else if entityType == "Snippet" {
            view.content.stringValue = (labeledList[row] as! SnippetMO).label!
            view.icon.image = NSImage(imageLiteralResourceName: "icon_snippet")
        }
        
        return view
    }
}

// MARK: SplitView Delegate
extension SearchViewController: NSSplitViewDelegate {
    func splitView(_ splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
        true
    }
    
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        proposedMinimumPosition + 220
    }
    
    func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        proposedMaximumPosition - 220
    }
}
