//
//  LoggingService.swift
//  N Clip Board
//
//  Created by nuc_mac on 2019/9/17.
//  Copyright © 2019 branson. All rights reserved.
//

import Foundation
import SwiftyBeaver

class LoggingService {
    static let logFileURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("/nClipBoard.log")
    private let log = SwiftyBeaver.self
    private let logWithFile = SwiftyBeaver.self
    
    static var shared: LoggingService = LoggingService.init()
    
    private init() {
        let fileDest = FileDestination()
        fileDest.logFileURL = LoggingService.logFileURL
        log.addDestination(ConsoleDestination())
        logWithFile.addDestination(fileDest)
        debugPrint("- logging service ready")
    }
    
    func info(_ message: Any) {
        logWithFile.info(message)
    }
    
    func debug(_ message: Any) {
        log.debug(message)
    }
    
    func warn(_ message: Any) {
        logWithFile.warning("⚠️ \(message)")
    }
    
    func error(_ message: Any) {
        logWithFile.error("🛑 \(message)")
    }
}
