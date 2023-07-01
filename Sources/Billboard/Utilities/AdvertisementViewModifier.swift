//
//  AdvertisementViewModifier.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import SwiftUI

extension View {
    public func showAdvertOverlay<V: View>(when condition: Binding<Bool>,
                                           configuration: BillboardConfiguration = BillboardConfiguration(),
                                           paywall: @escaping () -> V) -> some View {
        self.modifier(AdvertisementModifier(showAd: condition, config: configuration, paywall: paywall))
    }
}

public struct AdvertisementModifier<V: View>: ViewModifier {
    
    let showAd : Binding<Bool>
    let config : BillboardConfiguration
    let paywall: () -> V
    
    @ObservedObject private var monitor : BillboardViewModel
    
    init(showAd: Binding<Bool>, config: BillboardConfiguration, paywall: @escaping () -> V) {
        self.showAd = showAd
        self.config = config
        self.paywall = paywall
        self.monitor = BillboardViewModel(configuration: config)
    }
    
    @State private var advertisement: BillboardAd? = nil
    @State private var showPaywall = false
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: showAd.wrappedValue) { show in
                if show {
                    Task {
                        await monitor.showAdvertisement()
                    }
                }
            }
            .fullScreenCover(item: $monitor.advertisement, onDismiss: { showAd.wrappedValue = false }) { advert in
                AdvertisementView(advert: advert, config: config, paywall: { paywall() })
            }
    }
}
