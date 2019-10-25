//
//  AppDelegate.swift
//  Launcher
//
//  Created by nuc_mac on 2019/9/17.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        LoggingService.shared.info("Launcher launched...")

        // Insert code here to initialize your application
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == Constants.MainBundleName }.isEmpty

        if !isRunning {
            LoggingService.shared.info("Main Bundle Is Not Running")
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(terminateApp), name: .init("killlauncher"), object: Constants.MainBundleName)

            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("N Clip Board")

            let locationOfMainBundle = NSString.path(withComponents: components)
            LoggingService.shared.info("Location Of Main Bundle\n\(locationOfMainBundle)")

            NSWorkspace.shared.launchApplication(locationOfMainBundle)
        } else {
            LoggingService.shared.info("🔁 Main Bundle is already running")
            terminateApp()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        LoggingService.shared.warn("🛑 Launcher is now exit")
    }

    @objc func terminateApp() {
        NSApp.terminate(self)
    }

}

