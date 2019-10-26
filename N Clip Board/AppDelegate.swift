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
    
    let hk = HotKey(key: .v, modifiers: [.command, .shift])

    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        NSApp.appearance = NSAppearance(named: .aqua)
        registerTransformer()
        // kill launcher after main app was launched
        LoginService.killLauncher()
        
        ClipBoardService.mountTimer(onInsert: nil)
        
        statusItem.menu = statusBarMenu
        if let button = statusItem.button {
            button.image = NSImage(named: "n_status")
        }

        hk.keyDownHandler = {
            self.searchWindowController.showWindow(self)
        }
        
        // initialize UserDefaults configuration
        Utility.registerUserDefaults()
        Utility.monitorSystemEvents()
        UserDefaults.standard.addObserver(self, forKeyPath: Constants.Userdefaults.PollingInterval, options: [.new], context: nil)
        LoggingService.shared.info("application finished launching")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
      // Insert code here to tear down your application
        LoggingService.shared.warn("application will exit")
        ClipBoardService.unMountTimer()
    }
    
    func confirmBeforeCleanClipBoard() {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "Do you really want to clean up all items?"
        alert.informativeText = "This won't clean up the system pasteboard"
        alert.addButton(withTitle: "No")
        alert.addButton(withTitle: "Remove All")
        let result = alert.runModal()
        if result == .alertSecondButtonReturn {
            clearAllContent()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let PreferenceKey = Constants.Userdefaults.self

        switch keyPath {
        default:
            break
        }
    }
    
    func clearAllContent() {
        do {
            try ClipBoardService.clearRecord()
        } catch {
            warningBox(title: "Fail to clean up", message: error.localizedDescription)
        }
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
