//
//  BillboardAd.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import Foundation
import SwiftUI


struct BillboardAd : Codable, Identifiable, Equatable {
    
    static func == (lhs: BillboardAd, rhs: BillboardAd) -> Bool {
        lhs.id == rhs.id
    }
    
    var id : String {
        return "\(name)+\(appStoreID)"
    }
    
    /// Should be the Apple ID of App that's connected to the Ad (e.g. 1596487035)
    let appStoreID : String
    
    /// Name of ad (e.g. NowPlaying)
    let name : String
    
    /// Title that's displayed on the Ad (Recommended to be no more than 25 characters)
    let title : String
    
    /// Description that's displayed on the Ad (Recommended to be no more than 140 characters)
    let description : String
    
    /// URL of image that's used in the Ad
    let media : URL
    
    /// App Store Link based on `appStoreID`
    var appStoreLink : URL {
        return URL(string: "https://apps.apple.com/app/apple-store/id\(id)")!
    }

    /// Main Background color in HEX format
    let backgroundColor : String
    
    /// Text color in HEX format
    let textColor : String
    
    /// Main tint color in HEX format
    let tintColor : String
    
    
    /// For fullscreen media styling (should be true when the main image is a photo)
    let fullscreen: Bool
    
    /// Allows blurred background when the main image is a PNG
    let transparent : Bool
    
    var background : Color {
        return Color(hex: self.backgroundColor)
    }
    
    var text : Color {
        return Color(hex: self.textColor)
    }
    
    var tint : Color {
        return Color(hex: self.tintColor)
    }
    
}

