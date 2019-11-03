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
    @IBOutlet var masShortcutView: MASShortcutView!

    var initialSize: CGSize = .init(width: 480, height: 348)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storedShortCutValue = UserDefaults.standard.dictionary(forKey: Constants.Userdefaults.ActivationHotKeyDict) as? [String: Int] {
            
            let modifierRawValue = storedShortCutValue["modifier"]!
            let keyCode = storedShortCutValue["keyCode"]!
            masShortcutView.shortcutValue = MASShortcut(keyCode: keyCode, modifierFlags: .init(rawValue: UInt(modifierRawValue)))
        }
        masShortcutView.style = .texturedRect
//        masShortcutCiew.shortcutValue = .ini
        masShortcutView.shortcutValueChange = { sender in
            var useModifier: Int, useKeyCode: Int
            
            if let shortcut = sender?.shortcutValue {
                useModifier = Int(shortcut.modifierFlags.rawValue)
                useKeyCode = shortcut.keyCode
            } else {
                useModifier = Constants.defaultActivationHotKey["modifier"]!
                useKeyCode = Constants.defaultActivationHotKey["keyCode"]!
            }
            
            let shortcutValue: [String: Int] = ["modifier": useModifier, "keyCode": useKeyCode]
            UserDefaults.standard.set(shortcutValue, forKey: Constants.Userdefaults.ActivationHotKeyDict)

            let appDelegate = NSApp.delegate as! AppDelegate
            
            do {
                try appDelegate.setActivationHotKey()
            } catch {
                UserDefaults.standard.set(Constants.defaultActivationHotKey, forKey: Constants.Userdefaults.ActivationHotKeyDict)
            }
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
