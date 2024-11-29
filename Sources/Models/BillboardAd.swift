//
//  BillboardAd.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import Foundation
import SwiftUI

public struct BillboardAd: Codable, Identifiable, Hashable, Sendable {

    public init(
        appStoreID: String,
        name: String,
        title: String,
        description: String,
        category: AdCategory? = nil,
        media: URL,
        backgroundColor: String,
        textColor: String,
        tintColor: String,
        fullscreen: Bool,
        transparent: Bool
    ) {
        self.appStoreID = appStoreID
        self.name = name
        self.title = title
        self.description = description
        self.media = media
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.tintColor = tintColor
        self.adCategory = category?.rawValue
        self.fullscreen = fullscreen
        self.transparent = transparent
    }
    
    public static func == (lhs: BillboardAd, rhs: BillboardAd) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public var id : String {
        return "\(name)+\(appStoreID)"
    }
    
    /// Should be the Apple ID of App that's connected to the Ad (e.g. 1596487035)
    public let appStoreID: String
    
    /// Name of ad (e.g. NowPlaying)
    public let name: String
    
    /// Title that's displayed on the Ad (Recommended to be no more than 25 characters)
    public let title: String
    
    /// Description that's displayed on the Ad (Recommended to be no more than 140 characters)
    public let description: String
    
    /// URL of image that's used in the Ad
    public let media: URL
    
    /// App Store Link based on `appStoreID`
    public var appStoreLink: URL? {
        return URL(string: "https://apps.apple.com/app/id\(appStoreID)")
    }

    /// Main Background color in HEX format
    public let backgroundColor: String
    
    /// Text color in HEX format
    public let textColor: String
    
    /// Main tint color in HEX format
    public let tintColor: String
    
    
    public let adCategory: String?
    
    
    /// For fullscreen media styling (should be true when the main image is a photo)
    public let fullscreen: Bool
    
    /// Allows blurred background when the main image is a PNG
    public let transparent: Bool
    
    public var background: Color {
        return Color(hex: self.backgroundColor)
    }
    
    public var text: Color {
        return Color(hex: self.textColor)
    }
    
    public var tint: Color {
        return Color(hex: self.tintColor)
    }
    
    public var category: AdCategory {
        AdCategory(rawValue: adCategory ?? "") ?? .none
    }
    
    public var appIconURL: URL? {
        return URL(string: "http://itunes.apple.com/lookup?id=\(appStoreID)")
    }
    
    public func getAppIcon() async throws -> Data? {
        guard let appIconURL else { return nil }
        let session = URLSession(configuration: BillboardViewModel.networkConfiguration)
        session.sessionDescription = "Fetching App Icon"
        
        do {
            let (data, _) = try await session.data(from: appIconURL)
            let decoder = JSONDecoder()
            let response = try decoder.decode(AppIconResponse.self, from: data)
            guard let artworkUrlStr = response.results.first?.artworkUrl100, let artworkURL = URL(string: artworkUrlStr) else { return nil }
            
            return try? Data(contentsOf: artworkURL)
            
        } catch {
            return nil
        }

    }
}




