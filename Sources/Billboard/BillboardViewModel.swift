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
    
    public func showAdvertisement() async {
        if let newAd = try? await fetchRandomAd() {
            await MainActor.run {
                advertisement = newAd
            }
        }
    }
    
    public func fetchRandomAd() async throws -> BillboardAd? {
        guard let url = configuration.adsJSONURL else { return nil }
        
        let config = URLSessionConfiguration.default
        config.multipathServiceType = .handover
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        let session = URLSession(configuration: config)
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
    
    public func fetchAllAds() async throws -> [BillboardAd] {
        guard let url = configuration.adsJSONURL else { return [] }
        
        let config = URLSessionConfiguration.default
        config.multipathServiceType = .handover
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        let session = URLSession(configuration: config)
        session.sessionDescription = "Fetching Billboard Ad"
        
        
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
