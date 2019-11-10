//
//  ColorView.swift
//  N Clip Board
//
//  Created by branson on 2019/11/10.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

@IBDesignable
class ColorView: NSView {
    @IBInspectable var color: NSColor?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
        guard let useColor = color else { return }
        useColor.setFill()
        NSRect(origin: CGPoint(x: 0, y: 0), size: frame.size).fill()
    }
    
}
