//
//  AdCategory.swift
//  Billboard
//
//  Created by Hidde van der Ploeg on 29/11/2024.
//


public enum AdCategory: String, CaseIterable, Sendable {
    case none
    case books
    case business
    case developerTools
    case education
    case entertainment
    case finance
    case foodAndDrink
    case games
    case graphicsAndDesign
    case health
    case lifestyle
    case magazinesAndNewspapers
    case medical
    case music
    case navigation
    case news
    case photoAndVideo
    case productivity
    case reference
    case shopping
    case socialNetworking
    case sports
    case stickers
    case travel
    case utilities
    case weather
    
    
    public var title: String {
        switch self {
            case .developerTools:
                "Developer Tools"
            case .foodAndDrink:
                "Food & Drink"
            case .graphicsAndDesign:
                "Graphics & Design"
            case .health:
                "Health & Fitness"
            case .magazinesAndNewspapers:
                "Magazines & Newspapers"
            case .photoAndVideo:
                "Photo & Video"
            case .socialNetworking:
                "Social Networking"
            default:
                self.rawValue.capitalized
        }
    }
}
