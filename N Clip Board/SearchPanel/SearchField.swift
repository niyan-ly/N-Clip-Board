//
//  SearchFieldView.swift
//  N Clip Board
//
//  Created by branson on 2019/10/20.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

@objc protocol SearchFieldDelegate {
    @objc optional func arrowDown()
    @objc optional func arrowUp()
}

class SearchField: NSTextField {
    
    var arrowDelegate: SearchFieldDelegate?

    override func keyUp(with event: NSEvent) {
        // [arrow down]: 125, [arrow up]: 126
        switch event.keyCode {
        case 125:
            arrowDelegate?.arrowDown?()
        case 126:
            arrowDelegate?.arrowUp?()
        default:
            break
        }
    }
    
}
