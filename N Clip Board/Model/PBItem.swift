//
//  ClipBoardItem.swift
//  N Clip Board
//
//  Created by branson on 2019/10/15.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

@objc(PBItem)
class PBItem: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PBItem> {
        return NSFetchRequest<PBItem>(entityName: "PBItem")
    }
    
    @NSManaged public var content: String
    @NSManaged public var time: Date
    @NSManaged public var index: Int
}
