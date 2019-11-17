//
//  StoreService.swift
//  N Clip Board
//
//  Created by branson on 2019/10/29.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class StoreService: NSObject {
    @objc dynamic lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Store")
        container.loadPersistentStores { (description, error) in
            if error != nil {
                fatalError("\(error!)")
            }
        }
        
        return container
    }()
    
    @objc dynamic var managedContext: NSManagedObjectContext {
        get { persistentContainer.viewContext }
    }
    
    // MARK: Singleton initializer
    private override init() {
        
    }
    
    @objc dynamic static let shared = StoreService()
}
