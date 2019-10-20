//
//  Util.swift
//  N Clip Board
//
//  Created by branson on 2019/9/13.
//  Copyright © 2019 branson. All rights reserved.
//

import Foundation

extension String {
    mutating func trim() {
        self = self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    subscript(_ i: Int) -> String {
        let idx1 = index(startIndex, offsetBy: i)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start ..< end])
    }
    
    subscript (r: CountableClosedRange<Int>) -> String {
        let endNum = r.upperBound > self.count ? self.count : r.upperBound
        let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: endNum - r.lowerBound)
         
        return String(self[startIndex..<endIndex])
    }
}

extension Notification.Name {
    static let ShouldReloadCoreData = NSNotification.Name("ShouldReloadCoreData")
}
