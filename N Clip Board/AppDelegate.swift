//
//  AppDelegate.swift
//  N Clip Board
//
//  Created by branson on 2019/9/8.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa
import HotKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let searchWindowController = SearchWindowController(windowNibName: "SearchPanel")
    let hk = HotKey(key: .space, modifiers: [.control])

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        searchWindowController.showWindow(self)
        hk.keyDownHandler = {
            self.searchWindowController.showWindow(self)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
      // Insert code here to tear down your application
    }
    
}
