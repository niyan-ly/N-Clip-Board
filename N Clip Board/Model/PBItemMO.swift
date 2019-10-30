//
//  ClipBoardItem.swift
//  N Clip Board
//
//  Created by branson on 2019/10/15.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

@objc(PBItemMO)
class PBItemMO: LabeledMO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PBItemMO> {
        return NSFetchRequest<PBItemMO>(entityName: "PBItem")
    }

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        
        entityType = "PBItem"
    }
}
