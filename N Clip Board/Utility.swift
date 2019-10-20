//
//  Utility.swift
//  N Clip Board
//
//  Created by nuc_mac on 2019/10/11.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

final class Utility {
    static func registerUserDefaults() {
        var preferenceDict = Dictionary<String, Any>.init()
        
        preferenceDict[Constants.Userdefaults.LaunchOnStartUp] = false
        preferenceDict[Constants.Userdefaults.ShowCleanUpMenuItem] = false
        preferenceDict[Constants.Userdefaults.KeepClipBoardItemUntil] = 30
        preferenceDict[Constants.Userdefaults.PollingInterval] = 0.4
        preferenceDict[Constants.Userdefaults.ShowPollingIntervalLabel] = false
        preferenceDict[Constants.Userdefaults.LastPasteBoardChangeCount] = NSPasteboard.general.changeCount
        
        UserDefaults.standard.register(defaults: preferenceDict)
    }
    
    @discardableResult
    static func shell(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
}

func warningBox(title: String, message: String) {
    let alert = NSAlert()
    alert.alertStyle = .warning
    alert.messageText = title
    alert.informativeText = message
    
    alert.runModal()
}
