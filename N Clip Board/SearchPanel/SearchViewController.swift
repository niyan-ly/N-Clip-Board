//
//  SearchViewController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/11.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class CPCellView: NSTableCellView {
    @IBOutlet weak  var content: NSTextField!
    @IBOutlet weak var icon: NSButton!
    @IBOutlet weak var color: ColorView!
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
    var rowIndexToRemove: Int? = nil
    
    @objc dynamic var managedContext: NSManagedObjectContext {
        get { StoreService.shared.managedContext }
    }
    
    @objc dynamic var dataFilter: NSPredicate?
    @objc dynamic var sortDescripter = Constants.genSortDescriptor()
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
    // MARK: contentview
    @IBOutlet weak var textContainerView: NSScrollView!
    @IBOutlet weak var colorView: ColorView!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var creationDateView: NSTextField!
    @IBOutlet weak var textView: NSTextView!

    @IBOutlet weak var containerWindow: NSWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitorArrowEvent()
        updateViewTypeTriggerStyle()
        dataListController.addObserver(self, forKeyPath: "arrangedObjects", options: [.new], context: nil)

        viewTrigger.toolTip = "Show All Content"

        textView.font = NSFont.systemFont(ofSize: 14)
        searchField.isBezeled = false
        searchField.focusRingType = .none
        searchField.font = NSFont.systemFont(ofSize: 28, weight: .light)
        view.window?.standardWindowButton(.zoomButton)?.isHidden = true
        view.window?.standardWindowButton(.closeButton)?.isHidden = true
        view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        
        // register handler for core data reload event
        // only will be triggered on clea
        NotificationCenter.default.addObserver(forName: .ShouldReloadCoreData, object: nil, queue: nil) { (notice) in
            self.dataListController.fetch(self)
        }
    }
    
    override func awakeFromNib() {
        loadContentView()
    }
    
    override func viewWillAppear() {
        searchField.becomeFirstResponder()
        dataListController.fetch(self)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "arrangedObjects":
            willChangeValue(forKey: "dataCount")
            didChangeValue(forKey: "dataCount")
        default:
            break
        }
    }
    
    func loadContentView() {
        contentView.subviews = [
            textContainerView,
            colorView,
            imageView
        ]
        
        colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        textContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        textContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        textContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        textContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
    }
    
    func activateContentView(of view: NSView) {
        contentView.subviews.forEach { (subView) in
            if type(of: subView) == type(of: view) {
                subView.isHidden = false
            } else {
                subView.isHidden = true
            }
        }
    }
    
    func switchContentView(item: LabeledMO?) {
        guard let labeld = item else {
            contentView.subviews = []
            return
        }
        
        creationDateView.stringValue = ValueTransformer(forName: .DateToString)?.transformedValue(labeld.createdAt) as? String ?? ""

        if labeld.entityType == "PBItem" {
            let pbItem = labeld as! PBItemMO
            let contentType = NSPasteboard.PasteboardType(pbItem.contentType)
            
            switch contentType {
            case .png:
                let image = NSImage(data: pbItem.content!)
                imageView.image = image
                activateContentView(of: imageView)
            case .color:
                let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(pbItem.content!) as? NSColor
                colorView.color = color
                activateContentView(of: colorView)
            case .string:
                let stringValue = String(data: pbItem.content!, encoding: .utf8) ?? ""
                textView.string = stringValue
                activateContentView(of: textContainerView)
            default:
                LoggingService.shared.warn("unknown type of PBItem to handle with")
                return
            }
        }
        
        if labeld.entityType == "Snippet" {
            let snippet = labeld as! SnippetMO
            if let data = snippet.content {
                let stringValue = String(data: data, encoding: .utf8) ?? ""
                textView.string = stringValue
            } else {
                textView.string = ""
            }
            
            activateContentView(of: textContainerView)
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
                if $0.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
                    self.searchField.becomeFirstResponder()
                    return nil
                }
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
            case 2:
                if $0.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
                    guard let labeled = self.dataListController.selectedObjects[0] as? LabeledMO else { return $0 }
                    if labeled.entityType == "PBItem" {
                        self.rowIndexToRemove = self.resultListView.selectedRow
                        self.tryToSelectNext()
                        self.resultListView.removeRows(at: .init(integer: self.rowIndexToRemove!), withAnimation: .slideDown)
                        return nil
                    }
                }
            // [Escape key]: 53
            case 53:
                self.containerWindow.close()
                return nil
            default:
                break
            }
            return $0
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
        @unknown default:
            break;
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
            switchContentView(item: labeld[0])
        }
    }
    
    func tryToSelectNext() {
        guard let labeled = dataListController.arrangedObjects as? [LabeledMO] else { return }
        guard labeled.count > 0 else { return }
        
        if dataListController.selectionIndex < labeled.count - 1 {
            dataListController.setSelectionIndex(dataListController.selectionIndex + 1)
        } else if dataListController.selectionIndex > 0 {
            dataListController.setSelectionIndex(dataListController.selectionIndex - 1)
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard dataListController.selectedObjects.count > 0 else {
            // try reset selectionIndex to first when it's empty
            tryToSelectFirst()
            return
        }

        let item = dataListController.selectedObjects[0] as? LabeledMO
        switchContentView(item: item)
    }
    
    func tableView(_ tableView: NSTableView, didRemove rowView: NSTableRowView, forRow row: Int) {
        guard row == -1, let index = rowIndexToRemove else { return }
        self.dataListController.remove(atArrangedObjectIndex: index)
        rowIndexToRemove = nil
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
                view.color.isHidden = true
                view.content.stringValue = String(data: item.content!, encoding: .utf8) ?? ""
                // update old constraint if needed
                view.constraints.first(where: { $0.constant == 72 })?.constant = 48
            case .png:
                view.content.stringValue = ""
                view.color.isHidden = true
            case .color:
                let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(item.content!) as? NSColor
                view.content.stringValue = Utility.hexColor(color: color!)
                view.color.isHidden = false
                view.color.color = color
                // update constraint, the default textfield constant is 48
                view.constraints.first(where: { $0.firstAnchor == view.content.leadingAnchor })?.constant = 72
            default:
                view.content.stringValue = ""
            }

            if let identifier = item.bundleIdentifier {
                view.icon.image = Utility.findAppIcon(by: identifier)
            } else {
                view.icon.image = nil
            }
        } else if entityType == "Snippet" {
            view.content.stringValue = (labeledList[row] as! SnippetMO).label!
            view.icon.image = NSImage(imageLiteralResourceName: "icon_snippet")
            view.constraints.first(where: { $0.constant == 72 })?.constant = 48
            view.color.isHidden = true
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
