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
    @IBInspectable
    dynamic var color: NSColor?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
        guard let useColor = color else { return }
        useColor.setFill()
        NSRect(origin: CGPoint(x: 0, y: 0), size: frame.size).fill()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        wantsLayer = true
        layer?.cornerRadius = 4
        addObserver(self, forKeyPath: #keyPath(color), options: [.new], context: nil)
    }
    
//    override class var requiresConstraintBasedLayout: Bool {
//        get { true }
//    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "color" {
            needsDisplay = true
        }
    }
}
