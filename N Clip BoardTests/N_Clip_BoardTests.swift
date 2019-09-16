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

class N_Clip_BoardTests: XCTestCase {

    var fileUrl = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("n_clip_board_test.txt")
    
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
    
    func testFile() throws {
        guard FileManager.default.fileExists(atPath: fileUrl.path) else {
            do {
                print("file not exist")
                try "initial test content".write(to: fileUrl, atomically: true, encoding: .utf8)
            } catch {
                throw error
            }
            return
        }
        
        print("file exist")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
