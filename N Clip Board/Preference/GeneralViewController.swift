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
    
    var initialSize: CGSize = .init(width: 480, height: 360)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func clipBoardExpireDateChange(_ sender: NSPopUpButton) {
        print(sender.selectedItem?.tag)
    }
    
    @IBAction func toggleClearUpBtnInMenu(_ sender: NSButton) {
    
    }
    
    @IBAction func confirmBeforeCleanClipBoard(_ sender: NSButton) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "Do you really want to clean up all items?"
        alert.informativeText = "This can't be undo"
        alert.addButton(withTitle: "No")
        alert.addButton(withTitle: "Remove All")
        let result = alert.runModal()
        print(result == .alertSecondButtonReturn)
    }
    
    func clearAllContent() {
        
    }
}
