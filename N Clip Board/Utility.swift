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
        preferenceDict[Constants.Userdefaults.ExcludedAppDict] = [:]
        
        UserDefaults.standard.register(defaults: preferenceDict)
    }

    // referenced from https://stackoverflow.com/questions/26971240/how-do-i-run-an-terminal-command-in-a-swift-script-e-g-xcodebuild
    @discardableResult
    static func shell(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    static func findAppIcon(by bundleIdentifier: String) -> NSImage? {
        guard let bundlePath = NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: bundleIdentifier) else { return nil }
        
        return NSWorkspace.shared.icon(forFile: bundlePath)
    }
    
    static func getAppLocalizedName(by bundleIdentifier: String) -> String? {
        guard let bundlePath = NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: bundleIdentifier) else {
            LoggingService.shared.warn("Fail to find bundle \(bundleIdentifier)")
            return nil
        }
        
        return FileManager.default.displayName(atPath: bundlePath)
    }
}

func warningBox(title: String, message: String) {
    let alert = NSAlert()
    alert.alertStyle = .warning
    alert.messageText = title
    alert.informativeText = message
    
    alert.runModal()
}
