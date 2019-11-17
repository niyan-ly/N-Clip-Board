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
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        entityType = "Snippet"
        label = "label"
    }
}

extension SnippetMO: NSPasteboardWriting {
    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [.string]
    }
    
    func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
        return content
    }
    
    
}
