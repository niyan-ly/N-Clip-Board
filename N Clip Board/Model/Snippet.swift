//
//  Snippet.swift
//  N Clip Board
//
//  Created by branson on 2019/10/29.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

@objc(SnippetMO)
class SnippetMO: LabeledMO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PBItemMO> {
        return NSFetchRequest<PBItemMO>(entityName: "SnippetMO")
    }

    @NSManaged public var name: String
    @NSManaged public var createdAt: Date
}
