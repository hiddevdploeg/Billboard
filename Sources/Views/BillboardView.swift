//
//  BillboardView.swift
//
//  Created by Hidde van der Ploeg on 27/06/2022.
//

import SwiftUI
import StoreKit

public struct BillboardView<Content:View>: View {
    let advert : BillboardAd
    let config : BillboardConfiguration
    
    @ViewBuilder var paywall: () -> Content
    
    @State private var showPaywall : Bool = false
    @State private var canDismiss = false
    
    public init(advert: BillboardAd, config: BillboardConfiguration = BillboardConfiguration(), paywall: @escaping () -> Content) {
        self.advert = advert
        self.config = config
        self.paywall = paywall
    }
    
    public var body: some View {
    #if os(visionOS)
        NavigationStack {
            ZStack(alignment: .top) {
                advert.background.ignoresSafeArea()
                if advert.fullscreen {
                    FullScreenAdView(advert: advert)
                } else {
                    DefaultAdView(advert: advert)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if canDismiss {
                        BillboardDismissButton()
                            .onAppear {
                                #if os(iOS)
                                if config.allowHaptics {
                                    haptics(.light)
                                }
                                #endif
                            }
                    } else {
                        BillboardCountdownView(advert: advert,
                                               totalDuration: config.duration,
                                               canDismiss: $canDismiss)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showPaywall.toggle()
                    } label: {
                        Text("Remove Ads")
                            .font(.system(.footnote, design: .rounded))
                            .bold()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
        }
        .sheet(isPresented: $showPaywall) { paywall() }
        .onAppear(perform: displayOverlay)
        .onDisappear(perform: dismissOverlay)
        .onChange(of: showPaywall) {
            if showPaywall {
                dismissOverlay()
            } else {
                displayOverlay()
            }
        }
        #elseif os(tvOS)
        ZStack(alignment: .top) {
            advert.background.ignoresSafeArea()
            if advert.fullscreen {
                FullScreenAdView(advert: advert)
            } else {
                DefaultAdView(advert: advert)
            }
            HStack {
                if canDismiss {
                    BillboardDismissButton()
                } else {
                    BillboardCountdownView(advert: advert,
                                           totalDuration: config.duration,
                                           canDismiss: $canDismiss)
                }
                Spacer()
                if #available(tvOS 26.0, *) {
                    Button("Remove Ads") {
                        showPaywall.toggle()
                    }
                    .fontWeight(.bold)
                    .buttonStyle(.glass)
                } else {
                    Button("Remove Ads") {
                        showPaywall.toggle()
                    }
                    .fontWeight(.bold)
                    .buttonStyle(.bordered)
                }
            }
            .frame(height: 40)
            .tint(advert.tint)
            .padding()
        }
        .background(advert.background.ignoresSafeArea())
        .sheet(isPresented: $showPaywall) { paywall() }
#else
        NavigationStack {
            ZStack(alignment: .top) {
                advert.background.ignoresSafeArea()
                if advert.fullscreen {
                    FullScreenAdView(advert: advert)
                } else {
                    DefaultAdView(advert: advert)
                }
            }
            .background(advert.background.ignoresSafeArea())
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                #if !os(tvOS)
                if canDismiss {
                    ToolbarItem(placement: .cancellationAction) {
                        BillboardDismissButton()
                            .labelStyle(.iconOnly)
                    }
                } else {
                    ToolbarItem(placement: .cancellationAction) {
                        BillboardCountdownView(advert: advert,
                                               totalDuration: config.duration,
                                               canDismiss: $canDismiss)
                            .padding(2)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Remove Ads") {
                        showPaywall.toggle()
                    }
                    .fontWeight(.bold)
                    .controlSize(.small)
                }
                #endif
            }
        }
        .sheet(isPresented: $showPaywall) { paywall() }
        #if !os(macOS)
        .onAppear(perform: displayOverlay)
        .onDisappear(perform: dismissOverlay)
        .onChange(of: showPaywall) {
            if showPaywall {
                dismissOverlay()
            } else {
                displayOverlay()
            }
        }
        .statusBarHidden(true)
        #endif
        #endif
    }
    
    //MARK: - App Store Overlay
    #if !(os(tvOS) || os(macOS))
    private var storeOverlay : SKOverlay {
        let config = SKOverlay.AppConfiguration(appIdentifier: advert.appStoreID, position: .bottom)
        let overlay = SKOverlay(configuration: config)
        return overlay
    }
    
    private let scene = UIApplication.shared.connectedScenes
        .compactMap({ scene -> UIWindow? in
            (scene as? UIWindowScene)?.keyWindow
        })
        .first?
        .windowScene
    
    private func dismissOverlay() {
        guard let scene else { return }
        SKOverlay.dismiss(in: scene)
    }
    
    private func displayOverlay() {
        guard let scene else { return }
        storeOverlay.present(in: scene)
        
        #if os(iOS)
        if config.allowHaptics {
            haptics(.heavy)
        }
        #endif
    }
    #endif
}


#Preview {
    BillboardView(advert: BillboardSamples.sampleDefaultAd) {
        VStack {
            Spacer()
            BillboardBannerView(advert: BillboardSamples.sampleDefaultAd)
            Spacer()
        }
    }
}

