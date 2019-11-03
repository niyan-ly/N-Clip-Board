//
//  N_Clip_BoardTests.swift
//  N Clip BoardTests
//
//  Created by nuc_mac on 2019/9/16.
//  Copyright © 2019 branson. All rights reserved.
//

import XCTest
import Foundation

@testable import N_Clip_Board
@testable import HotKey

class N_Clip_BoardTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testKeyCode() {
        let key = Key(carbonKeyCode: 9)
        switch key {
        case .v:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }
}
