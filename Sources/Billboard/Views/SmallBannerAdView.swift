//
//  SmallBannerAdView.swift
//  
//
//  Created by Hidde van der Ploeg on 03/07/2023.
//

import SwiftUI

public struct SmallBannerAdView : View {
    @Environment(\.accessibilityReduceMotion) private var reducedMotion
    @Environment(\.openURL) private var openURL
    
    let advert : BillboardAd
    let config : BillboardConfiguration
    
    @State private var canDismiss = false
    @State private var appIcon : UIImage? = nil
    @State private var showAdvertisement = true
    
    public init(advert: BillboardAd, config: BillboardConfiguration = BillboardConfiguration()) {
        self.advert = advert
        self.config = config
    }
    
    public var body: some View {
        
        HStack(spacing: 10) {
            Button {
                openURL(advert.appStoreLink)
                canDismiss = true
            } label: {
                HStack(spacing: 10) {
                    if let appIcon {
                        Image(uiImage: appIcon)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        
                        BillboardAdInfoLabel(advert: advert)
                        
                        VStack(alignment: .leading) {
                            Text(advert.title)
                                .font(.system(.footnote, design: .rounded, weight: .bold))
                                .foregroundColor(advert.text)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                            Text(advert.name)
                                .font(.system(.caption2, design: .rounded, weight: .medium).smallCaps())
                                .foregroundColor(advert.tint)
                                .opacity(0.8)
                        }
                    }
                }
            }
            .buttonStyle(.plain)
            Spacer()
            
            if canDismiss {
                Button {
                    if config.allowHaptics {
                        haptics(.light)
                    }
                    
                    withAnimation(.spring()) {
                        showAdvertisement = false
                    }
                    
                } label: {
                    Label("Dismiss advertisement", systemImage: "xmark.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .imageScale(.large)
                        .controlSize(.large)
                }
                .tint(advert.tint)
            } else {
                BillboardCountdownView(advert:advert,
                                       totalDuration: config.duration,
                                       canDismiss: $canDismiss)
                .padding(.trailing, 2)
            }
            
        }
        .padding(10)
        .background(advert.background)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        
        .task {
            if let data = try? await advert.getAppIcon() {
                appIcon = UIImage(data: data)
            }
        }
        .opacity(showAdvertisement ? 1 : 0)
        .scaleEffect(showAdvertisement ? 1 : 0)
        .frame(height: showAdvertisement ? nil : 0)
        .transaction {
            if reducedMotion { $0.animation = nil }
        }
        
    }
}


struct SmallBannerAdView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SmallBannerAdView(advert: BillboardSamples.sampleDefaultAd)
            SmallBannerAdView(advert: BillboardSamples.sampleDefaultAd)
        }
        .padding()
        
    }
}
