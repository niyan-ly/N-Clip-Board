//
//  FileWatcher.swift
//  N Clip Board
//
//  Created by nuc_mac on 2019/9/16.
//  Copyright © 2019 branson. All rights reserved.
//

import Foundation

class FileWatcher {
    private var managedItems: [URL: NSFilePresenter] = [:]
    
    private class Presenter: NSObject, NSFilePresenter {
        var presentedItemURL: URL?
        var callback: () -> Void
        var presentedItemOperationQueue: OperationQueue = OperationQueue.main
        
        init(itemURL: URL, handler: @escaping () -> Void) {
            presentedItemURL = itemURL
            callback = handler
            super.init()
        }
        
        func presentedItemDidChange() {
            callback()
        }
    }
    
    deinit {
        for (_, p) in managedItems.values.enumerated() {
            NSFileCoordinator.removeFilePresenter(p)
        }
    }
    
    func watch(at url: URL, handler: @escaping () -> Void) throws -> NSFilePresenter {
        if managedItems.keys.contains(url) {
            throw NError.FileAlreadyBeenWatched
        }
        
        let presenter = FileWatcher.Presenter(itemURL: url, handler: handler)
        managedItems[url] = presenter
        return presenter
    }
    
    func removeWatcher(at url: URL) {
        guard managedItems.keys.contains(url) else { return }
        
        NSFileCoordinator.removeFilePresenter(managedItems.removeValue(forKey: url)!)
    }
}
