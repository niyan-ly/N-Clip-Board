//
//  AdvancedViewController.swift
//  N Clip Board
//
//  Created by branson on 2019/9/15.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class PollingIntervalTransformer: ValueTransformer {
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return Double.self as! AnyClass
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let validValue = value as? Double else { return nil }
        
        return Double(String(format: "%.2f", validValue))
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        return transformedValue(value)
    }
}

extension NSValueTransformerName {
    static let PollingIntervalTransformer = NSValueTransformerName("PollingIntervalTransformer")
}

class AdvancedViewController: NSViewController, ViewInitialSize {
    var initialSize: CGSize = .init(width: 520, height: 320)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        ValueTransformer.setValueTransformer(PollingIntervalTransformer(), forName: .PollingIntervalTransformer)
    }
//     {
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
    }
    
}
