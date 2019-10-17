//
//  ClipBoardHelper.swift
//  N Clip Board
//
//  Created by branson on 2019/9/13.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa



class ClipBoardService: NSObject {
    
    private static var onInsert: ((NSPasteboardItem) -> Void)? = nil
    
    @objc dynamic static var cpItems = [ClipBoardItem]()
    static fileprivate var timer: Timer?
    static fileprivate var changeCount = 0
    
    private static func readItem() {
        // MARK: detect whether paste updated or not
        guard changeCount != NSPasteboard.general.changeCount else { return }

        changeCount = NSPasteboard.general.changeCount

        guard let items = NSPasteboard.general.pasteboardItems else { return }

        for item in items {
            if onInsert != nil {
                onInsert!(item)
            }

            if let data = item.string(forType: .string) {
                willChangeValue(forKey: "cpItems")
                cpItems.append(.init(data))
                didChangeValue(forKey: "cpItems")
            }
        }
    }
    
    static func mountTimer(onInsert: ((NSPasteboardItem) -> Void)?) {
        self.onInsert = onInsert
        
        var pollingInterval = UserDefaults.standard.double(forKey: Constants.Userdefaults.PollingInterval)
        
        if !(0.2...1).contains(pollingInterval) {
            UserDefaults.standard.set(0.4, forKey: Constants.Userdefaults.PollingInterval)
            pollingInterval = 0.4
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: pollingInterval, repeats: true) { timer in
            self.readItem()
        }
    }
    
    @discardableResult
    static func unMountTimer() -> Bool {
        guard let t = timer else {
            return false
        }
        
        t.invalidate()
        return true
    }
    
    // reload timer
    static func reload() {
        unMountTimer()
        mountTimer(onInsert: onInsert)
    }
}
