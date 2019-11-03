//
//  ClipBoardHelper.swift
//  N Clip Board
//
//  Created by branson on 2019/9/13.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class ClipBoardService: NSObject {
    
    var lastItem: PBItemMO?
    fileprivate var timer: Timer?
    private var onInsert: ((NSPasteboardItem) -> Void)? = nil
    fileprivate var changeCount = NSPasteboard.general.changeCount
    
    @objc dynamic var pasteboardMirror = [PBItemMO]()
    
    // MARK: Singleton Initializer
    private override init() {
        super.init()

        observeManagedContext()
    }
    // MARK: Singleton shared instance
    static let shared = ClipBoardService()
    
    private func observeManagedContext() {
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: nil, queue: nil) { (notice) in
            self.syncMirrorFromStore()
        }
    }
    
    private func syncMirrorFromStore() {
        let fetchRequest: NSFetchRequest<PBItemMO> = PBItemMO.fetchRequest()
        do {
            pasteboardMirror = try StoreService.shared.managedContext.fetch(fetchRequest)
        } catch {
            pasteboardMirror = []
            LoggingService.shared.error("Error when sync pasteboardMirror: \(error)")
        }
    }
    
    private func saveUserCopiedItemIntoStore() {
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
                let item = PBItemMO(context: StoreService.shared.managedContext)
                item.index = changeCount
                item.content = data
                item.bundleIdentifier = SysMonitorService.shared.activatedAppBundleIdentifier
                lastItem = item
            }
        }
        
        if StoreService.shared.managedContext.hasChanges {
            do {
                try StoreService.shared.managedContext.save()
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
        print("monitor")
        self.onInsert = onInsert
        
        var pollingInterval = UserDefaults.standard.double(forKey: Constants.Userdefaults.PollingInterval)
        
        if !(0.2...1).contains(pollingInterval) {
            UserDefaults.standard.set(0.4, forKey: Constants.Userdefaults.PollingInterval)
            pollingInterval = 0.4
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: pollingInterval, repeats: true) { timer in
            self.saveUserCopiedItemIntoStore()
        }
    }
    
    @discardableResult
    func disableNSPasteboardMonitor() -> Bool {
        guard let t = timer else { return false }

        t.invalidate()
        return true
    }
    
    // reload timer
    func reloadMonitor() {
        disableNSPasteboardMonitor()
        enableNSPasteboardMonitor(onInsert: onInsert)
    }
    
    func clearRecord() throws {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: PBItemMO.fetchRequest())
        // execute batch request won't load data into memory, and take effect immediately
        // execute(:) won't make change to current context, so we have to manually reload
        // related view
        try StoreService.shared.managedContext.execute(deleteRequest)
        
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
