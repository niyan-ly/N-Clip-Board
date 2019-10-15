//
//  AppDelegate.swift
//  N Clip Board
//
//  Created by branson on 2019/9/8.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa
import HotKey
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var statusBarMenu: NSMenu!
    
    let searchWindowController = SearchWindowController(windowNibName: "SearchPanel")
    let preferenceWindowController = PreferencePanelController(windowNibName: "PreferencePanel")
    var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    let hk = HotKey(key: .space, modifiers: [.control])

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // kill launcher after main app was launched
        LoginService.killLauncher()
        ClipBoardHelper.mountTimer {
            guard let dataContent = $0.string(forType: .string) else { return }
            print(dataContent)
        }
        
        statusItem.menu = statusBarMenu
        if let button = statusItem.button {
            button.image = NSImage(named: "n_status")
        }

        hk.keyDownHandler = {
            self.searchWindowController.showWindow(self)
        }
        
        // MARK: - initialize UserDefaults configuration
        Utility.registerUserDefaults()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
      // Insert code here to tear down your application
        ClipBoardHelper.unMountTimer()
    }
    
    func confirmBeforeCleanClipBoard() {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "Do you really want to clean up all items?"
        alert.informativeText = "This can't be undo"
        alert.addButton(withTitle: "No")
        alert.addButton(withTitle: "Remove All")
        let result = alert.runModal()
        if result == .alertSecondButtonReturn {
            clearAllContent()
        }
    }
    
    func clearAllContent() {
        print("all clipBoard content cleared")
    }
    
    @IBAction func beforeCleaUp(_ sender: Any) {
        confirmBeforeCleanClipBoard()
    }
    
    @IBAction func showPreferencePanel(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        preferenceWindowController.window?.makeKeyAndOrderFront(self)
    }
    
    @IBAction func showAppInfoPanel(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(self)
    }
}
