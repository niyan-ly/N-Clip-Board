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
import Preferences

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // the life cycle of status bar is the same as application
    @IBOutlet var statusBarMenu: NSMenu!
    
    let searchWindowController = SearchWindowController(windowNibName: "SearchPanel")
    lazy var preferenceWindowController = PreferencesWindowController(preferencePanes: [
        GeneralViewController(),
        RulesViewController(),
        SnippetsViewController(),
        AdvancedViewController()
    ])
    
    var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var hk: HotKey?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // NSApp.appearance = NSAppearance(named: .aqua)
        registerTransformer()
        
        SysMonitorService.shared.start()
        
        ClipBoardService.shared.enableNSPasteboardMonitor()
        // kill launcher after main app was launched
        LoginService.killLauncher()
        
        statusItem.menu = statusBarMenu
        if let button = statusItem.button {
            button.image = NSImage(named: "n_status")
        }
        
        // initialize UserDefaults configuration
        Utility.registerUserDefaults()
        try? setActivationHotKey()

        LoggingService.shared.info("application finished launching")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
      // Insert code here to tear down your application
        LoggingService.shared.warn("application will exit")
        ClipBoardService.shared.disableNSPasteboardMonitor()
    }
    
    func setActivationHotKey() throws {
        guard let activationKey = UserDefaults.standard.dictionary(forKey: Constants.Userdefaults.ActivationHotKeyDict) else {
            throw NError.InValidActivationKey
        }
        
        guard let modifier = activationKey["modifier"] as? UInt, let keyCode = activationKey["keyCode"] as? UInt32 else {
            throw NError.InValidActivationKey
        }

        guard let key = Key(carbonKeyCode: keyCode) else {
            LoggingService.shared.error("Fail to setActivationHotKey, passed keyCode is: \(keyCode)")
            throw NError.InValidActivationKey
        }
        
        hk = HotKey(key: key, modifiers: NSEvent.ModifierFlags(rawValue: modifier))
        hk?.keyDownHandler = {
            self.searchWindowController.showWindow(self)
        }
    }
    
    func confirmBeforeCleanClipBoard() {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = NSLocalizedString("CleanUpMessage", comment: "")
        alert.informativeText = NSLocalizedString("CleanUpHint", comment: "")
        alert.addButton(withTitle: NSLocalizedString("CleanUpConfirmationOfNo", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("CleanUpConfirmationOfYes", comment: ""))
        let result = alert.runModal()
        if result == .alertSecondButtonReturn {
            clearAllContent()
        }
    }
    
    func clearAllContent() {
        do {
            try ClipBoardService.shared.clearRecord()
        } catch {
            warningBox(title: "Fail to clean up", message: error.localizedDescription)
        }
    }
    
    @IBAction func showSearchPanel(_ sender: Any) {
        searchWindowController.showWindow(self)
    }
    
    @IBAction func beforeCleaUp(_ sender: Any) {
        confirmBeforeCleanClipBoard()
    }
    
    @IBAction func showPreferencePanel(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        preferenceWindowController.show(preferencePane: .general)
    }
    
    @IBAction func showAppInfoPanel(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(self)
    }
}
