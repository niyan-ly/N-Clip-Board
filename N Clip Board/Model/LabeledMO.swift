//
//  Labeled+CoreDataClass.swift
//  N Clip Board
//
//  Created by branson on 2019/10/29.
//  Copyright © 2019 branson. All rights reserved.
//
//

import Foundation
import CoreData

@objc(LabeledMO)
public class LabeledMO: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LabeledMO> {
        return NSFetchRequest<LabeledMO>(entityName: "Labeled")
    }

    @NSManaged public var content: Data?
    @NSManaged public var entityType: String
    @NSManaged public var index: Int
    @NSManaged public var createdAt: Date
    @NSManaged public var label: String?

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createdAt = Date()
    }
}
