//
//  BillboardMonitor.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import SwiftUI

final class BillboardMonitor : ObservableObject {
    
    static let shared = BillboardMonitor()
    
    @Published var advertisement : BillboardAd? = nil
    
    var advertCountdown = 2
    
    var showAdvert : Bool {
        advertCountdown == 0
    }
    
    @MainActor
    func resetAdvertCountdown() {
        advertCountdown = 2
        advertisement = nil
    }
    
    func fetchRandomAd() async throws -> BillboardAd? {
        guard let url = BillboardConstants.adsURL else { return nil }
        
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
    
    func fetchAllAds() async throws -> [BillboardAd] {
        guard let url = BillboardConstants.adsURL else { return [] }
        
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
    
    @MainActor
    func updateAdvert() async {
        if self.showAdvert {
            self.advertisement = try? await self.fetchRandomAd()
            return
        }
        self.advertCountdown -= 1
    }
}
