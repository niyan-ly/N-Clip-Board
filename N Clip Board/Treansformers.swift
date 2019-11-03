//
//  Treansformers.swift
//  N Clip Board
//
//  Created by branson on 2019/10/19.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

fileprivate class PollingIntervalTransformer: ValueTransformer {
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

fileprivate class OmitRedundantText: ValueTransformer {
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let validValue = value as? String else { return nil }
        
        return validValue.trimmingCharacters(in: .whitespacesAndNewlines)[0...22].trimmingCharacters(in: .whitespacesAndNewlines).appending(validValue.count < 22 ? "" : "...")
    }
}

extension NSValueTransformerName {
    static let PollingIntervalTransformer = NSValueTransformerName("PollingIntervalTransformer")
    static let OmitRedundantText = NSValueTransformerName(rawValue: "OmitRedundantText")
}

func registerTransformer() {
    ValueTransformer.setValueTransformer(PollingIntervalTransformer(), forName: .PollingIntervalTransformer)
    ValueTransformer.setValueTransformer(OmitRedundantText(), forName: .OmitRedundantText)
}
