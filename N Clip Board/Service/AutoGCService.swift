//
//  AutoGCService.swift
//  N Clip Board
//
//  Created by branson on 2019/11/16.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class AutoGCService {
    private static var lastCollectTime = Date()
    private static let duration: TimeInterval = 60 * 60 * 5

    /**
            
        Trigger action of clean up expired clip item
     
     No matter how many times call, action of collect will only work as configured.
     */
    static func collect() {
        guard lastCollectTime.timeIntervalSinceNow * -1 > duration else { return }
        
        lastCollectTime = Date()
        
        let expireDuration = UserDefaults.standard.integer(forKey: Constants.Userdefaults.KeepClipBoardItemUntil)
        let expiredDate = Date(timeIntervalSinceNow: TimeInterval(-1 * 60 * 60 * 24 * expireDuration))
        let fetchRequest: NSFetchRequest<PBItemMO> = PBItemMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "createdAt < %@", argumentArray: [expiredDate])

        do {
            let result = try StoreService.shared.managedContext.fetch(fetchRequest)
            result.forEach({ StoreService.shared.managedContext.delete($0) })
        } catch {
            LoggingService.shared.error("Fail to collect expired clip item: \(error)")
        }
    }
}
