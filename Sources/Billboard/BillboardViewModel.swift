//
//  BillboardMonitor.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import SwiftUI

public final class BillboardViewModel : ObservableObject {
    
    let configuration: BillboardConfiguration
    
    @Published var advertisement : BillboardAd? = nil
    
    init(configuration: BillboardConfiguration = BillboardConfiguration()) {
        self.configuration = configuration
    }
    
    public static var networkConfiguration : URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.multipathServiceType = .handover
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        return config
    }
    
    public func showAdvertisement() async {
        guard let url = configuration.adsJSONURL else { return }

        if let newAd = try? await BillboardViewModel.fetchRandomAd(from: url) {
            await MainActor.run {
                advertisement = newAd
            }
        }
    }
    
    public static func fetchRandomAd(from url: URL) async throws -> BillboardAd? {
        let session = URLSession(configuration: BillboardViewModel.networkConfiguration)
        session.sessionDescription = "Fetching Billboard Ad"
        
        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(BillboardAdResponse.self, from: data)
            let adToShow = response.ads.randomElement()
            return adToShow
            
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    public static func fetchAllAds(from url: URL) async throws -> [BillboardAd] {
        let session = URLSession(configuration: BillboardViewModel.networkConfiguration)
        session.sessionDescription = "Fetching All Billboard Ads"
                
        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(BillboardAdResponse.self, from: data)
            return response.ads
            
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    
}
