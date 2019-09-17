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

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.contentView?.addSubview(NSTextField(labelWithString: LoggingService.logFileURL.path))
        // Insert code here to initialize your application
        let mainAppIdentifier = "poor-branson.N-Clip-Board"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty

        if !isRunning {
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(terminateApp), name: .init("killlauncher"), object: mainAppIdentifier)

            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("N Clip Board")

            let newPath = NSString.path(withComponents: components)
            LoggingService.shared.info(newPath)

            NSWorkspace.shared.launchApplication(newPath)
        } else {
            terminateApp()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func terminateApp() {
        NSApp.terminate(self)
    }

}

