//
//  ClipBoardHelper.swift
//  N Clip Board
//
//  Created by branson on 2019/9/13.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class ClipBoardService: NSObject {
    
    private var onInsert: ((NSPasteboardItem) -> Void)? = nil
    
    var lastItem: PBItem?
    fileprivate var timer: Timer?
    fileprivate var changeCount = NSPasteboard.general.changeCount
    
    // MARK: Core Data Suits
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PBStore")
        container.loadPersistentStores { (description, error) in
            if error != nil {
                fatalError("\(error!)")
            }
        }
        
        return container
    }()
    
    lazy var managedContext = {
        persistentContainer.viewContext
    }()
    
    // MARK: Singleton Initializer
    private override init() {
        super.init()
        
        enableNSPasteboardMonitor(onInsert: nil)
    }
    // MARK: Singleton shared instance
    static var shared = ClipBoardService()
    
    private func loadNewestItemFromNSPasteboard() {
        // MARK: detect whether paste updated or not
        guard changeCount != NSPasteboard.general.changeCount else { return }
        
        changeCount = NSPasteboard.general.changeCount
        
        guard let items = NSPasteboard.general.pasteboardItems else { return }

        for item in items {
            if onInsert != nil {
                onInsert!(item)
            }
            
            if let data = item.string(forType: .string) {
                // skip duplicated content
                if lastItem?.content == data {
                    break
                }
                let item = PBItem(context: managedContext)
                item.index = changeCount
                item.content = data
                item.time = Date()
                lastItem = item
            }
        }
        
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                fatalError("\(error)")
            }
        }
    }
    
    func write(content: String) {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(content, forType: .string)
    }
    
    func enableNSPasteboardMonitor(onInsert: ((NSPasteboardItem) -> Void)?) {
        self.onInsert = onInsert
        
        var pollingInterval = UserDefaults.standard.double(forKey: Constants.Userdefaults.PollingInterval)
        
        if !(0.2...1).contains(pollingInterval) {
            UserDefaults.standard.set(0.4, forKey: Constants.Userdefaults.PollingInterval)
            pollingInterval = 0.4
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: pollingInterval, repeats: true) { timer in
            self.loadNewestItemFromNSPasteboard()
        }
    }
    
    @discardableResult
    func disableNSPasteboardMonitor() -> Bool {
        guard let t = timer else {
            return false
        }
        
        t.invalidate()
        return true
    }
    
    // reload timer
    func reloadMonitor() {
        disableNSPasteboardMonitor()
        enableNSPasteboardMonitor(onInsert: onInsert)
    }
    
    func clearRecord() throws {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: PBItem.fetchRequest())
        // execute batch request won't load data into memory, and take effect immediately
        // execute(:) won't make change to current context, so we have to manually reload
        // related view
        try managedContext.execute(deleteRequest)
        
        NotificationCenter.default.post(name: .ShouldReloadCoreData, object: nil)
    }
    
    // MARK: paste
    func paste() {
        let keyCodeOfV: CGKeyCode = 9
        DispatchQueue.main.async {
            let source = CGEventSource(stateID: .combinedSessionState)
            // Disable local keyboard events while pasting
            source?.setLocalEventsFilterDuringSuppressionState([.permitLocalMouseEvents, .permitSystemDefinedEvents], state: .eventSuppressionStateSuppressionInterval)
            // Press Command + V
            let keyVDown = CGEvent(keyboardEventSource: source, virtualKey: keyCodeOfV, keyDown: true)
            keyVDown?.flags = .maskCommand
            // Release Command + V
            let keyVUp = CGEvent(keyboardEventSource: source, virtualKey: keyCodeOfV, keyDown: false)
            keyVUp?.flags = .maskCommand
            // Post Paste Command
            keyVDown?.post(tap: .cgAnnotatedSessionEventTap)
            keyVUp?.post(tap: .cgAnnotatedSessionEventTap)
        }
    }
}
