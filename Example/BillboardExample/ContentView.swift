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
    @State private var adtoshow: BillboardAd? = nil
    @State private var allAds: [BillboardAd] = []
    @State private var bannerAd: BillboardAd? = nil
    
    let config = BillboardConfiguration(advertDuration: 5)
    
    var body: some View {
        NavigationStack {
            List {
                if let bannerAd {
                    Section {
                        BillboardBannerView(advert: bannerAd, hideDismissButtonAndTimer: true)
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
            if let bannerAd {
                BillboardBannerView(advert: bannerAd)
                    .padding()
                
            }
        })
        .refreshable {
            Task {
                if let allAds = try? await BillboardViewModel.fetchAllAds(from: config.adsJSONURL!) {
                    self.allAds = allAds
                    self.bannerAd = allAds.randomElement()
                }
            }
        }
        .onChange(of: premium.didBuyPremium, {
            if premium.didBuyPremium {
                showRandomAdvert = !premium.didBuyPremium
            }
        })
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
                bannerAd = allAds.randomElement()
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
