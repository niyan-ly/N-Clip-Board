//
//  AdvancedViewController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/15.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa
import Preferences

class AppearanceViewController: NSViewController, PreferencePane {
    var preferencePaneIdentifier: Identifier = .appearance
    var preferencePaneTitle: String = PreferencePaneIdentifier.appearance.rawValue
    var toolbarItemIcon: NSImage = #imageLiteral(resourceName: "toolbar_advanced")

    override var preferredContentSize: NSSize {
        get { NSSize(width: 520, height: 180) }
        set {}
    }
}
