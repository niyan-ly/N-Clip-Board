//
//  SysMonitorService.swift
//  N Clip Board
//
//  Created by branson on 2019/11/1.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class SysMonitorService: NSObject {
    private var isServiceInitialized = false
    
    private var _activatedAppBundleIdentifier: String?
    var activatedAppBundleIdentifier: String? {
        get { _activatedAppBundleIdentifier }
    }
    
    static var shared = SysMonitorService()
    
    private override init() {}
    
    func start() {
        if !isServiceInitialized {
            isServiceInitialized = true
            
            monitorActivatedApp()
            monitorSysStatu()
        } else {
            LoggingService.shared.error("SysMonitorService tried to initialize more than once")
        }
    }
    
    func monitorActivatedApp() {
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didActivateApplicationNotification, object: nil, queue: nil) { (notice) in
            if let userInfo = notice.userInfo {
                guard let app = userInfo[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
                    LoggingService.shared.warn("Fail to cast activated application into NSRunningApplication")
                    return
                }
                
                self._activatedAppBundleIdentifier = app.bundleIdentifier
            }
        }
    }
    
    func monitorSysStatu() {
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: nil) { (notice) in
            LoggingService.shared.warn("screen will going to sleep")
            ClipBoardService.shared.disableNSPasteboardMonitor()
            // try to clean up expired clip item
            AutoGCService.collect()
        }
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil) { (notice) in
            LoggingService.shared.warn("screen awaked")
            ClipBoardService.shared.enableNSPasteboardMonitor()
        }
    }
}
