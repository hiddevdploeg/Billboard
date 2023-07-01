//
//  BillboardAd.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import Foundation
import SwiftUI


public struct BillboardAd : Codable, Identifiable, Equatable {
    
    public static func == (lhs: BillboardAd, rhs: BillboardAd) -> Bool {
        lhs.id == rhs.id
    }
    
    public var id : String {
        return "\(name)+\(appStoreID)"
    }
    
    /// Should be the Apple ID of App that's connected to the Ad (e.g. 1596487035)
    public let appStoreID : String
    
    /// Name of ad (e.g. NowPlaying)
    public let name : String
    
    /// Title that's displayed on the Ad (Recommended to be no more than 25 characters)
    public let title : String
    
    /// Description that's displayed on the Ad (Recommended to be no more than 140 characters)
    public let description : String
    
    /// URL of image that's used in the Ad
    public let media : URL
    
    /// App Store Link based on `appStoreID`
    public var appStoreLink : URL {
        return URL(string: "https://apps.apple.com/app/apple-store/id\(id)")!
    }

    /// Main Background color in HEX format
    public let backgroundColor : String
    
    /// Text color in HEX format
    public let textColor : String
    
    /// Main tint color in HEX format
    public let tintColor : String
    
    
    /// For fullscreen media styling (should be true when the main image is a photo)
    public let fullscreen: Bool
    
    /// Allows blurred background when the main image is a PNG
    public let transparent : Bool
    
    public var background : Color {
        return Color(hex: self.backgroundColor)
    }
    
    public var text : Color {
        return Color(hex: self.textColor)
    }
    
    public var tint : Color {
        return Color(hex: self.tintColor)
    }
    
}

