//
//  StringConstants.swift
//  N Clip Board
//
//  Created by branson on 2019/10/1.
//  Copyright © 2019 branson. All rights reserved.
//

fileprivate let BundleName = "poor-branson.N-Clip-Board"

struct Constants {
    static let MainBundleName = BundleName
    static let LauncherBundleName = "launcher.".appending(BundleName)
    
    // MARK: - UserDefaults key name
    struct Userdefaults {
        static let LaunchOnStartUp = "LaunchOnStartUp"
        static let KeepClipBoardItemUntil = "KeepClipBoardItemUntil"
        static let ShowCleanUpMenuItem = "ShowCleanUpMenuItem"
        static let PollingInterval = "PollingInterval"
        static let ShowPollingIntervalLabel = "ShowPollingIntervalLabel"
    }
}

enum SearchPanelViewType {
    case All
    case ClipBoard
    case Snippet
}
