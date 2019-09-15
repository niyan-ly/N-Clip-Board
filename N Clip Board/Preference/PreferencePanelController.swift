//
//  PreferencePanelController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/13.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

typealias PreferenceSubView = NSToolbarItem.Identifier
extension PreferenceSubView {
    static let general = PreferenceSubView("general")
    static let advanced = PreferenceSubView("advanced")
    static let snippets = PreferenceSubView("snippets")
    static let info = PreferenceSubView("info")
}

public protocol ViewInitialSize: NSViewController {
    var initialSize: CGSize { get }
}

class PreferencePanelController: NSWindowController {
    @IBOutlet var toolbar: NSToolbar!
    
    var generalViewController = GeneralViewController(nibName: "GeneralViewController", bundle: nil)
    var snippetsViewController = SnippetsViewController(nibName: "SnippetsViewController", bundle: nil)
    var advancedViewController = AdvancedViewController(nibName: "AdvancedViewController", bundle: nil)

    override func windowDidLoad() {
        super.windowDidLoad()
        switchView(of: .general)
    }
    
    func switchView(of viewIdentifier: PreferenceSubView) {
        var usedViewController: ViewInitialSize!
        switch viewIdentifier {
        case .general:
            usedViewController = generalViewController
        case .advanced:
            usedViewController = advancedViewController
            break
        case .info:
            break
        case .snippets:
            usedViewController = snippetsViewController
            break
        default:
            return
        }

        toolbar.selectedItemIdentifier = viewIdentifier as NSToolbarItem.Identifier

        let currentFrame = window!.frame
        let newOrigin = CGPoint(x: currentFrame.origin.x, y: currentFrame.origin.y + currentFrame.size.height - usedViewController.initialSize.height)
        
        window?.setFrame(CGRect(origin: newOrigin, size: usedViewController.initialSize), display: true, animate: true)
        window?.contentView = usedViewController.view
    }
    
    @IBAction func whenToolbarChange(_ sender: NSButton) {
        let mapper = [0: PreferenceSubView("general"), 1: PreferenceSubView("snippets"), 2: PreferenceSubView("advanced"), 3: PreferenceSubView("info")]
        switchView(of: mapper[sender.tag] ?? .general)
    }
}

extension PreferencePanelController: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            NSToolbarItem.Identifier("general"),
            NSToolbarItem.Identifier("snippets"),
            NSToolbarItem.Identifier("advanced"),
            NSToolbarItem.Identifier("info"),
        ]
    }
}
