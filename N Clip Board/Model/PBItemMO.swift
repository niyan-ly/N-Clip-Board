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
    
    @NSManaged var bundleIdentifier: String?
    @NSManaged var contentType: String
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        entityType = "PBItem"
    }
}

extension PBItemMO: NSPasteboardWriting {
    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        let itemType = NSPasteboard.PasteboardType(contentType)
        return itemType == .color ? [.string, itemType] : [itemType]
    }
    
    func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
        return content
    }
    
    func writingOptions(forType type: NSPasteboard.PasteboardType, pasteboard: NSPasteboard) -> NSPasteboard.WritingOptions {
        return []
    }
}
