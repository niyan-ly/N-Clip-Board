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
}
