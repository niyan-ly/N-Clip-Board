//
//  SearchWindowController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/11.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class SearchWindowController: NSWindowController, NSWindowDelegate {
    override func windowDidLoad() {
        super.windowDidLoad()
        customizeWindow()
//        window?.contentView?.setFrameSize(CGSize(width: 480, height: 200))
//        window?.isFloatingPanel = true
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    func customizeWindow() {
        guard let panel = window as? NSPanel else {
            print("cast search window failed")
            return
        }
        
        panel.level = .popUpMenu
    }
    
    func windowDidResignKey(_ notification: Notification) {
        window?.close()
    }
}
