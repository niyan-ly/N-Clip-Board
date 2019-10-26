//
//  GeneralViewController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/15.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa
import MASShortcut

class GeneralViewController: NSViewController, ViewInitialSize {
    @IBOutlet var keepItemView: NSStackView!
    @IBOutlet var cleanUpView: NSStackView!
    @IBOutlet var masShortcutCiew: MASShortcutView!

    var initialSize: CGSize = .init(width: 480, height: 320)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        masShortcutCiew.style = .texturedRect
        masShortcutCiew.shortcutValueChange = { sender in
            print(sender?.shortcutValue?.modifierFlags)
            print(sender?.shortcutValue?.keyCode)
        }
    }
    
    @IBAction func clipBoardExpireDateChange(_ sender: NSPopUpButton) {
//        print(sender.selectedItem?.tag)
    }
    
    @IBAction func toggleLaunchAtStartUp(_ sender: NSButton) {
        switch sender.state {
        case .on:
            LoginService.enable()
        default:
            LoginService.disable()
        }
    }
}
