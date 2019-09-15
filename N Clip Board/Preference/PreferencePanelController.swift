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
    static let general = PreferenceSubView("General")
    static let advanced = PreferenceSubView("Advanced")
    static let snippets = PreferenceSubView("Snippets")
    static let info = PreferenceSubView("Info")
    static let appearance = PreferenceSubView("Appearance")
}

public protocol ViewInitialSize: NSViewController {
    var initialSize: CGSize { get }
}

class PreferencePanelController: NSWindowController {
    @IBOutlet var toolbar: NSToolbar!
    
    var generalViewController = GeneralViewController(nibName: "GeneralViewController", bundle: nil)
    var snippetsViewController = SnippetsViewController(nibName: "SnippetsViewController", bundle: nil)
    var advancedViewController = AdvancedViewController(nibName: "AdvancedViewController", bundle: nil)
    var appearanceViewController = AppearanceViewController(nibName: "AppearanceViewController", bundle: nil)

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
        case .appearance:
            usedViewController = appearanceViewController
            break
        case .snippets:
            usedViewController = snippetsViewController
            break
        default:
            return
        }

        window?.title = viewIdentifier.rawValue
        toolbar.selectedItemIdentifier = viewIdentifier as NSToolbarItem.Identifier

        let currentFrame = window!.frame
        let newOrigin = CGPoint(x: currentFrame.origin.x, y: currentFrame.origin.y + currentFrame.size.height - usedViewController.initialSize.height)
        
        window?.setFrame(CGRect(origin: newOrigin, size: usedViewController.initialSize), display: true, animate: true)
        window?.contentView = usedViewController.view
    }
    
    @IBAction func whenToolbarChange(_ sender: NSToolbarItem) {
        switchView(of: sender.itemIdentifier as PreferenceSubView)
    }
}

