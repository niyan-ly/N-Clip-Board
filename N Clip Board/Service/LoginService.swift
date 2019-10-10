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
        SMLoginItemSetEnabled(Constants.LauncherBundleName as CFString, true)
        
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == Constants.LauncherBundleName }.isEmpty
        
        if isRunning {
            DistributedNotificationCenter.default().post(name: .init("killlauncher"), object: Bundle.main.bundleIdentifier!)
        }
    }
    
    static func disable() {
        SMLoginItemSetEnabled(Constants.LauncherBundleName as CFString, false)
    }
}
