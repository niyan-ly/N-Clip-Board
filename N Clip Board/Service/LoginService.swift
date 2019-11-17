//
//  LoginService.swift
//  N Clip Board
//
//  Created by branson on 2019/10/1.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa
import ServiceManagement

class LoginService {

    static func enable() {
        LoggingService.shared.info("🤖 Enable launch on boot")
        if SMLoginItemSetEnabled(Constants.LauncherBundleName as CFString, true) {
            LoggingService.shared.info("service management request successed")
        } else {
            LoggingService.shared.info("service management request failed")
        }
        
        killLauncher()
    }
    
    static func disable() {
        LoggingService.shared.info("🛑 Disable launch on boot")
        SMLoginItemSetEnabled(Constants.LauncherBundleName as CFString, false)
    }
    
    static func killLauncher() {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == Constants.LauncherBundleName }.isEmpty
        
        if isRunning {
            LoggingService.shared.warn("kill launcher")
            DistributedNotificationCenter.default().post(name: .init("killLauncher"), object: Bundle.main.bundleIdentifier!)
        }
    }
}
