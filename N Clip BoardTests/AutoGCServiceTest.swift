//
//  AutoGCService.swift
//  N Clip BoardTests
//
//  Created by branson on 2019/11/16.
//  Copyright © 2019 branson. All rights reserved.
//

import XCTest

@testable import N_Clip_Board

class AutoGCServiceTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        UserDefaults.standard.set(3, forKey: Constants.Userdefaults.KeepClipBoardItemUntil)
        let expiredItem = PBItemMO(context: StoreService.shared.managedContext)
        let validItem = PBItemMO(context: StoreService.shared.managedContext)
        expiredItem.contentType = "string"
        validItem.contentType = "string"
        expiredItem.label = "expired"
        validItem.label = "valid"
        // mock
        expiredItem.createdAt = Date(timeIntervalSinceNow: 60 * 60 * 24 * 4 * -1)
        
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = LabeledMO.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        try! StoreService.shared.managedContext.execute(deleteRequest)
//        try! StoreService.shared.managedContext.save()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheckout() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        AutoGCService.collect()
        let fetchRequest: NSFetchRequest<PBItemMO> = PBItemMO.fetchRequest()
        let result = try! StoreService.shared.managedContext.fetch(fetchRequest)
        assert(result.count == 1)
        assert(result[0].label == "valid")
    }

}
