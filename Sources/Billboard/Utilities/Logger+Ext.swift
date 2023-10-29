//
//  Logger+Ext.swift
//
//
//  Created by Hidde van der Ploeg on 29/10/2023.
//

import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    /// Logs coming from the Billboard SPM
    static let billboard = Logger(subsystem: subsystem, category: "Billboard")
}
