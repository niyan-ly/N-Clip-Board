//
//  ClipBoardItem.swift
//  N Clip Board
//
//  Created by branson on 2019/10/15.
//  Copyright © 2019 branson. All rights reserved.
//

import Foundation


final class ClipBoardItem {
    struct ClipBoardReceiver {
        var appName: String
        var bundleID: String
    }
    
    var content: String
    var receiver: ClipBoardReceiver?
    var time: Date
    
    init(_ content: String) {
        self.content = content
        self.time = Date()
    }
    
    init(_ content: String, receiver: ClipBoardReceiver) {
        self.content = content
        self.receiver = receiver
        self.time = Date()
    }
}
