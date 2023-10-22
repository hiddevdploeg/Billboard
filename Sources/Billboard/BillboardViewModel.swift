//
//  BillboardViewModel.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import Foundation

public final class BillboardViewModel : ObservableObject {
    
    let configuration: BillboardConfiguration
    
    @Published public var advertisement : BillboardAd? = nil
    
    public init(configuration: BillboardConfiguration = BillboardConfiguration()) {
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

        if let newAd = try? await BillboardViewModel.fetchRandomAd(from: url, excludedIDs: configuration.excludedIDs) {
            await MainActor.run {
                advertisement = newAd
            }
        }
    }
    
    public static func fetchRandomAd(from url: URL, excludedIDs: [String] = []) async throws -> BillboardAd? {
        let session = URLSession(configuration: BillboardViewModel.networkConfiguration)
        session.sessionDescription = "Fetching Billboard Ad"
        
        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(BillboardAdResponse.self, from: data)
            let filteredAds = response.ads.filter({ !excludedIDs.contains($0.appStoreID) })
            let adToShow = filteredAds.randomElement()
            return adToShow
            
        } catch DecodingError.keyNotFound(let key, let context) {
            print("❌ Failed to decode due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            print("❌ Failed to decode from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("❌ Failed to decode from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            print("❌ Failed to decode from bundle because it appears to be invalid JSON")
        } catch {
            print("❌ Failed to decode  from bundle: \(error.localizedDescription)")
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
            
        } catch DecodingError.keyNotFound(let key, let context) {
            print("❌ Failed to decode due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            print("❌ Failed to decode from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("❌ Failed to decode from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            print("❌ Failed to decode from bundle because it appears to be invalid JSON")
        } catch {
            print("❌ Failed to decode  from bundle: \(error.localizedDescription)")
        }
        
        return []
    }
    
    
}
