//
//  AdvancedViewController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/15.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa
import Preferences

class AdvancedViewController: NSViewController, PreferencePane {
    var preferencePaneIdentifier: Identifier = .advanced
    var preferencePaneTitle: String = "Advanced"
    var toolbarItemIcon: NSImage = #imageLiteral(resourceName: "toolbar_advanced")
    override var preferredContentSize: NSSize {
        get { NSSize(width: 520, height: 180) }
        set {}
    }
    
    @objc dynamic var logFilePath = LoggingService.logFileURL.path[0...36].appending("...")
    @IBOutlet weak var pollingIntervalPopover: NSPopover!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func showPopoverView(_ sender: NSButton) {
        switch sender.tag {
        case 1:
            pollingIntervalPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
        default:
            break
        }
    }
    
    @IBAction func sliderEvent(_ sender: NSSlider) {
        switch NSApp.currentEvent?.type {
        case .leftMouseDown:
            UserDefaults.standard.set(true, forKey: Constants.Userdefaults.ShowPollingIntervalLabel)
        case .leftMouseUp:
            UserDefaults.standard.set(false, forKey: Constants.Userdefaults.ShowPollingIntervalLabel)
            ClipBoardService.shared.reloadMonitor()
        default:
            break
        }
    }
    
    @IBAction func openLogFileInFinder(_ sender: Any) {
        let path = LoggingService.logFileURL.path as NSString
        var pathComponents = path.pathComponents
        pathComponents.removeLast()
        
        Utility.shell("open", "-b", "com.apple.finder", NSString.path(withComponents: pathComponents))
    }
}
