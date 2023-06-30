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
    
    // Should be the App Store ID e.g. 1596487035
    let appStoreID : String
    
    let name : String
    let title : String
    let description : String
    
    let media : URL
    
    /// App Store Link
    var appStoreLink : URL {
        return URL(string: "https://apps.apple.com/app/apple-store/id\(id)")!
    }
    

    /// Main Background color in HEX format
    let backgroundColor : String
    let textColor : String
    let ctaColor : String
    
    
    /// For fullscreen media styling (should be true when the main image is a photo
    let isFullscreen: Bool
    let transparentBG : Bool
    
    
    
    var background : Color {
        return Color(hex: self.backgroundColor)
    }
    
    var text : Color {
        return Color(hex: self.textColor)
    }
    
    var cta : Color {
        return Color(hex: self.ctaColor)
    }
}

