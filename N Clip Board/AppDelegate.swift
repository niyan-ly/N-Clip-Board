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
        let launcherId = "poor-branson.Launcher"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherId }.isEmpty
        
        SMLoginItemSetEnabled(launcherId as CFString, true)
        if isRunning {
            DistributedNotificationCenter.default().post(name: .init("killlauncher"), object: Bundle.main.bundleIdentifier!)
        }
        
        statusItem.menu = statusBarMenu
        if let button = statusItem.button {
            button.image = NSImage(named: "n_status")
        }

        hk.keyDownHandler = {
            self.searchWindowController.showWindow(self)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
      // Insert code here to tear down your application
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
