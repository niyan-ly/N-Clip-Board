//
//  GeneralViewController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/15.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class GeneralViewController: NSViewController, ViewInitialSize {
    @IBOutlet var keepItemView: NSStackView!
    @IBOutlet var cleanUpView: NSStackView!
    
    var initialSize: CGSize = .init(width: 480, height: 320)

    override func viewDidLoad() {
        super.viewDidLoad()
        // whether to show clean up menu or not
        if UserDefaults.standard.bool(forKey: Constants.Userdefaults.ShowCleanUpMenuItem) {
            
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
