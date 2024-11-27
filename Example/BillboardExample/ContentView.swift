//
//  ContentView.swift
//  BillboardExample
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI
import Billboard

struct ContentView: View {
    
    @StateObject var premium = PremiumStore()
    
    @State private var showRandomAdvert = false
    @State private var adtoshow :BillboardAd? = nil
    @State private var allAds : [BillboardAd] = []
    
    let config = BillboardConfiguration(advertDuration: 5)
    
    var body: some View {
        NavigationStack {
            List {
                if let advert = allAds.randomElement() {
                    Section {
                        BillboardBannerView(advert: advert, hideDismissButtonAndTimer: true)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                
                Section(content: {
                    Text("This example shows some different ways of presenting an ad but also lets you explore all Ads that are available right now!")
                    Button {
                        if !premium.didBuyPremium {
                            showRandomAdvert = true
                        }
                        
                        
                    } label: {
                        HStack {
                            Image(systemName: "eyes")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                                .padding(2)
                            Text("Show me a random ad!")
                        }
                        .padding(6)
                    }
                    
                }, footer: { Text("Total Ads: \(allAds.count)") })
                
                Section {
                    ForEach(allAds) { ad in
                        Button {
                            adtoshow = ad
                        } label: {
                            Text(ad.name)
                                .padding(6)
                        }
                        
                    }
                }
            }
            .font(.system(.body, design: .rounded, weight: .medium))
        }
        .safeAreaInset(edge: .bottom, content: {
            if let advert = allAds.randomElement() {
                BillboardBannerView(advert: advert)
                    .padding()
                
            }
        })
        .refreshable {
            Task {
                if let allAds = try? await BillboardViewModel.fetchAllAds(from: config.adsJSONURL!) {
                    self.allAds = allAds
                }
            }
        }
        .onChange(of: premium.didBuyPremium) { newValue in
            if newValue {
                showRandomAdvert = !newValue
            }
        }
        .showBillboard(when: $showRandomAdvert) {
            // Replace this view with your Paywall
            VStack {
                Text("Your Paywall goes here")
                Button {
                    premium.buyPremium()
                } label: {
                    Text("Fake purchase premium")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .fullScreenCover(item: $adtoshow) { advert in
            BillboardView(advert: advert, config: config, paywall: { Text("Paywall!") })
        }
        .task {
            
            if let allAds = try? await BillboardViewModel.fetchAllAds(from: config.adsJSONURL!) {
                self.allAds = allAds
            }
        }
    }
        
}

@MainActor
final class PremiumStore : ObservableObject {
    @Published var didBuyPremium = false
    
    func buyPremium() {
        didBuyPremium = true
    }
}
