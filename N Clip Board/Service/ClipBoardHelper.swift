//
//  ClipBoardHelper.swift
//  N Clip Board
//
//  Created by branson on 2019/9/13.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa



struct ClipBoardHelper {
    
    static fileprivate var isTimerSetted = false
    static fileprivate var timer: Timer?
    static fileprivate var changeCount = NSPasteboard.general.changeCount
    
    private init() {}
    
    fileprivate static func readItem(onInsert: (NSPasteboardItem) -> Void) {
        // MARK: detect whether paste updated or not
        guard changeCount != NSPasteboard.general.changeCount else { return }
        
        changeCount = NSPasteboard.general.changeCount
        
        guard let items = NSPasteboard.general.pasteboardItems else { return }

        for item in items {
            onInsert(item)
        }
    }
    
    static func mountTimer(onInsert: @escaping (NSPasteboardItem) -> Void) {
        if isTimerSetted {
            print(NError.ClipBoardTimerHasSetted)
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { timer in
                self.readItem(onInsert: onInsert)
            }
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
}
