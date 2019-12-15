//
//  N_Clip_BoardTests.swift
//  N Clip BoardTests
//
//  Created by branson on 2019/12/15.
//  Copyright © 2019 branson. All rights reserved.
//

import XCTest

@testable import N_Clip_Board

class N_Clip_BoardTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let fetchRequest: NSFetchRequest<PBItemMO> = PBItemMO.fetchRequest()
        let items = try? StoreService.shared.managedContext.fetch(fetchRequest)
        items?.forEach {
            let item = PBItemMO(context: StoreService.shared.managedContext)
            item.contentType = $0.contentType
            item.content = $0.content
            item.createdAt = $0.createdAt
            item.entityType = $0.entityType
            item.label = $0.label
            item.index = $0.index
            item.bundleIdentifier = $0.bundleIdentifier
        }
        
        do {
            try StoreService.shared.managedContext.save()
            print("wirte success")
        } catch {
            fatalError("\(error)")
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
