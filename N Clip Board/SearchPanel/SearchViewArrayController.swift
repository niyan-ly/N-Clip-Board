//
//  SearchViewArrayController.swift
//  N Clip Board
//
//  Created by branson on 2019/11/9.
//  Copyright © 2019 branson. All rights reserved.
//

import Cocoa

class SearchViewArrayController: NSArrayController {
    override func arrange(_ objects: [Any]) -> [Any] {
        let objs = objects as NSArray
        
        return objs.sortedArray(using: sortDescriptors).filter { (rawItem) -> Bool in
            guard let item = rawItem as? LabeledMO else { return false }
            
            guard let pbItem = item as? PBItemMO else {
                let snippet = item as! SnippetMO
                let content = String(data: snippet.content ?? .init(), encoding: .utf8)
                return filterPredicate?.evaluate(with: item, substitutionVariables: ["CONTENT": content!]) ?? false
            }
            
            guard pbItem.contentType == Constants.stringTypeRawValue else { return false }
            
            guard let content = String(data: pbItem.content!, encoding: .utf8) else { return false }

            return filterPredicate?.evaluate(with: item, substitutionVariables: ["CONTENT": content]) ?? false
        }
    }
}
