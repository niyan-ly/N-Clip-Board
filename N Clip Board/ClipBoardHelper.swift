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
    
    private init() {}
    
    static func readItem() {
        guard let items = NSPasteboard.general.pasteboardItems else { return }
        
        for item in items {
            print(item.string(forType: .string)!)
        }
    }
    
    static func mountTimer() {
        if isTimerSetted {
            print(NError.ClipBoardTimerHasSetted)
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
                self.readItem()
            }
        }
    }
    
    static func unloadTimer() -> Bool {
        guard let t = timer else {
            return false
        }
        
        t.invalidate()
        return true
    }
}
