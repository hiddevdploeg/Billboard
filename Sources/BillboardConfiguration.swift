//
//  BillboardConfiguration.swift
//
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import Foundation

public struct BillboardConfiguration {
    
    /// The URL pointing to the JSON in the `BillboardAdResponse` format.
    public let adsJSONURL: URL?
    
    /// Enable or disable haptics. This will be disabled on visionOS and macOS.
    public let allowHaptics: Bool
    
    /// The duration of the advertisement
    public let duration: TimeInterval
    
    /// Provide a list of Apple ID's that you want to exclude from showing up (e.g. your own app)
    public let excludedIDs : [String]
    
    /// All Categories that should be included in the ads that are shown
    public let categories : [String]
    
    public init(
        adsJSONURL: URL? = URL(string:"https://billboard-source.vercel.app/ads.json"),
        allowHaptics: Bool = true,
        advertDuration: TimeInterval = 15.0,
        excludedIDs: [String] = [],
        categories: [AdCategory] = AdCategory.allCases
    ) {
        self.adsJSONURL = adsJSONURL
        self.allowHaptics = allowHaptics
        self.duration = advertDuration
        self.excludedIDs = excludedIDs
        self.categories = categories.map { $0.rawValue }
    }
}
