//
//  StringConstants.swift
//  N Clip Board
//
//  Created by branson on 2019/10/1.
//  Copyright © 2019 branson. All rights reserved.
//
import Cocoa

fileprivate let BundleName = "poor-branson.N-Clip-Board"

struct Constants {
    static let MainBundleName = BundleName
    static let LauncherBundleName = "launcher.".appending(BundleName)
    static let defaultActivationHotKey = ["modifier": 1179648, "keyCode": 9]
    static let supportedPasteboardType: [NSPasteboard.PasteboardType] = [.string, .png, .color]
    static let stringTypeRawValue: String = NSPasteboard.PasteboardType.string.rawValue
    
    // MARK: - UserDefaults key name
    struct Userdefaults {
        static let LaunchOnStartUp = "LaunchOnStartUp"
        static let KeepClipBoardItemUntil = "KeepClipBoardItemUntil"
        static let ShowCleanUpMenuItem = "ShowCleanUpMenuItem"
        static let PollingInterval = "PollingInterval"
        static let ShowPollingIntervalLabel = "ShowPollingIntervalLabel"
        static let ExcludedAppDict = "ExcludedAppDict"
        static let ActivationHotKeyDict = "ActivationHotKeyDict"
    }
}

enum SearchPanelViewType: Int {
    case All = 0
    case ClipBoard
    case Snippet
}
