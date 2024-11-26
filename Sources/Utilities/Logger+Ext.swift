//
//  Logger+Ext.swift
//
//
//  Created by Hidde van der Ploeg on 29/10/2023.
//

import OSLog

extension Logger {
    /// Logs coming from the Billboard SPM
    static let billboard = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Billboard Package", category: "Billboard")
}
