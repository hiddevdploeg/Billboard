//
//  BillboardBannerView.swift
//
//  Created by Hidde van der Ploeg on 03/07/2023.
//

import SwiftUI
import OSLog

public struct BillboardBannerView : View {
    @Environment(\.accessibilityReduceMotion) private var reducedMotion
    @Environment(\.openURL) private var openURL
    
    let advert : BillboardAd
    let config : BillboardConfiguration
    let includeShadow : Bool
    let hideDismissButtonAndTimer : Bool
    
    @State private var canDismiss = false
    @State private var appIcon : NSUIImage? = nil
    @State private var showAdvertisement = true
    @State private var loadingNewIcon = true
    
    public init(advert: BillboardAd, config: BillboardConfiguration = BillboardConfiguration(), includeShadow: Bool = true, hideDismissButtonAndTimer: Bool = false) {
        self.advert = advert
        self.config = config
        self.includeShadow = includeShadow
        self.hideDismissButtonAndTimer = hideDismissButtonAndTimer
    }
    
    public var body: some View {
        #if os(tvOS)
        ZStack(alignment: .trailing) {
            Button {
                if let url = advert.appStoreLink {
                    openURL(url)
                    canDismiss = true
                }
            } label: {
                HStack(spacing: 20) {
                    ZStack {
                        if let appIcon, !loadingNewIcon {
                            Image(uiImage: appIcon)
                                .resizable()
                        } else {
                            advert.tint
                            ProgressView()
                                .foregroundStyle(advert.text)
                        }
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(.rect(cornerRadius: 26, style: .continuous))
                    .accessibilityHidden(true)
                    .transition(.blurReplace)
                    .animation(.default, value: loadingNewIcon)
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        BillboardAdInfoLabel(advert: advert)
                        
                        VStack(alignment: .leading) {
                            Text(advert.title)
                                .font(.system(.footnote, design: .rounded, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                            Text(advert.name)
                                .font(.system(.caption2, design: .rounded, weight: .medium).smallCaps())
                                .foregroundStyle(.secondary)
                        }
                    }
                    .foregroundStyle(advert.text)
                    .accessibilityHidden(true)
                    Spacer()
                }
                .padding(.trailing, hideDismissButtonAndTimer ? 0: 40)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            Group {
                if !hideDismissButtonAndTimer {
                    if canDismiss {
                        Button("Dismiss advertisement", systemImage: "xmark.circle.fill") {
                            showAdvertisement = false
                        }
                        .labelStyle(.iconOnly)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .imageScale(.large)
                        .buttonBorderShape(.circle)
                        .buttonStyle(.plain)
                    } else {
                        BillboardCountdownView(advert:advert,
                                               totalDuration: config.duration,
                                               canDismiss: $canDismiss)
                    }
                }
            }
            .padding(.trailing, 20)
        }
        .accessibilityLabel(Text("\(advert.name), \(advert.title)"))
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(advert.background.gradient)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                .shadow(color: includeShadow ? advert.background.opacity(0.5) : Color.clear, radius: 6, x: 0, y: 2)
        }
        .animation(.spring(), value: showAdvertisement)
        .task {
            await fetchAppIcon()
        }
        .opacity(showAdvertisement ? 1 : 0)
        .scaleEffect(showAdvertisement ? 1 : 0)
        .frame(height: showAdvertisement ? nil : 0)
        .transaction {
            if reducedMotion { $0.animation = nil }
        }
        .onChange(of: advert, {
            Task { await fetchAppIcon() }
        })
        #elseif os(visionOS)
        ZStack(alignment: .trailing) {
            Button {
                if let url = advert.appStoreLink {
                    openURL(url)
                    canDismiss = true
                }
            } label: {
                HStack(spacing: 10) {
                    ZStack {
                        if let appIcon, !loadingNewIcon {
                            Image(uiImage: appIcon)
                                .resizable()
                        } else {
                            advert.tint
                            ProgressView()
                                .foregroundStyle(advert.text)
                        }
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                    .accessibilityHidden(true)
                    .transition(.blurReplace)
                    .animation(.default, value: loadingNewIcon)
                    
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
                    .accessibilityHidden(true)
                    Spacer()
                }
                .padding(.trailing, hideDismissButtonAndTimer ? 0: 40)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            Group {
                if !hideDismissButtonAndTimer {
                    if canDismiss {
                        Button {
                        #if os(iOS)
                            if config.allowHaptics {
                                haptics(.light)
                            }
                            #endif
                            showAdvertisement = false
                        } label: {
#if os(visionOS)
                            Label("Dismiss advertisement", systemImage: "xmark")
                                .labelStyle(.iconOnly)
                                .font(.system(.title3, design: .rounded, weight: .bold))
                                .symbolRenderingMode(.hierarchical)
#else
                            Label("Dismiss advertisement", systemImage: "xmark.circle.fill")
                                .labelStyle(.iconOnly)
                                .font(.system(.title2, design: .rounded, weight: .bold))
                                .symbolRenderingMode(.hierarchical)
                                .imageScale(.large)
#endif
                        }
                        .controlSize(.large)
#if !os(visionOS)
                        .tint(advert.tint)
#endif
                    } else {
                        BillboardCountdownView(advert:advert,
                                               totalDuration: config.duration,
                                               canDismiss: $canDismiss)
                        .padding(.trailing, 2)
                    }
                }
            }
            .padding(.trailing, 9)
        }
        .accessibilityLabel(Text("\(advert.name), \(advert.title)"))
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 23, style: .continuous)
                .fill(advert.background.gradient)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                .shadow(color: includeShadow ? advert.background.opacity(0.5) : Color.clear, radius: 6, x: 0, y: 2)
        }
        .contentShape(.rect(cornerRadius: 18, style: .continuous))
        .animation(.spring(), value: showAdvertisement)
        .task {
            await fetchAppIcon()
        }
        .opacity(showAdvertisement ? 1 : 0)
        .scaleEffect(showAdvertisement ? 1 : 0)
        .frame(height: showAdvertisement ? nil : 0)
        .transaction {
            if reducedMotion { $0.animation = nil }
        }
        .onChange(of: advert, {
            Task { await fetchAppIcon() }
        })
        #else
        ZStack(alignment: .trailing) {
            Button {
                if let url = advert.appStoreLink {
                    openURL(url)
                    canDismiss = true
                }
            } label: {
                HStack(spacing: 10) {
                    ZStack {
                        if let appIcon, !loadingNewIcon {
                            Image(nsuiImage: appIcon)
                                .resizable()
                        } else {
                            advert.tint
                            ProgressView()
                                .foregroundStyle(advert.text)
                        }
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(.rect(cornerRadius: 13))
                    .accessibilityHidden(true)
                    .transition(.blurReplace)
                    .animation(.default, value: loadingNewIcon)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        BillboardAdInfoLabel(advert: advert)
                        
                        VStack(alignment: .leading) {
                            Text(advert.title)
                                .font(.system(.footnote, design: .rounded, weight: .bold))
                                .foregroundStyle(advert.text)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                            Text(advert.name)
                                .font(.system(.caption2, design: .rounded, weight: .medium).smallCaps())
                                .foregroundStyle(.secondary)
                        }
                    }
                    .foregroundStyle(advert.tint)
                    .accessibilityHidden(true)
                    Spacer()
                }
                .padding(.trailing, hideDismissButtonAndTimer ? 0: 40)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            Group {
                if !hideDismissButtonAndTimer {
                    if canDismiss {
                        Button("Dismiss advertisement", systemImage: "xmark.circle.fill") {
                            #if os(iOS)
                            if config.allowHaptics {
                                haptics(.light)
                            }
                            #endif
                            showAdvertisement = false
                        }
                        .labelStyle(.iconOnly)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .imageScale(.large)
                        .controlSize(.large)
                        .tint(advert.tint)
                    } else {
                        BillboardCountdownView(advert:advert,
                                               totalDuration: config.duration,
                                               canDismiss: $canDismiss)
                        .padding(.trailing, 2)
                    }
                }
            }
            .padding(.trailing, 10)
        }
        .accessibilityLabel(Text("\(advert.name), \(advert.title)"))
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 23, style: .continuous)
                .fill(advert.background.gradient)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                .shadow(color: includeShadow ? advert.background.opacity(0.5) : Color.clear, radius: 6, x: 0, y: 2)
        }
        .contentShape(.rect(cornerRadius: 18, style: .continuous))
        .animation(.spring(), value: showAdvertisement)
        .task {
            await fetchAppIcon()
        }
        .opacity(showAdvertisement ? 1 : 0)
        .scaleEffect(showAdvertisement ? 1 : 0)
        .frame(height: showAdvertisement ? nil : 0)
        .transaction {
            if reducedMotion { $0.animation = nil }
        }
        .onChange(of: advert, {
            Task { await fetchAppIcon() }
        })
#endif
        
    }
    
    
    private func fetchAppIcon() async {
        defer { loadingNewIcon = false }
        do {
            loadingNewIcon = true
            let imageData = try await advert.getAppIcon()
            if let imageData {
                await MainActor.run {
                    appIcon = NSUIImage(data: imageData)
                }
            }
        } catch {
            Logger.billboard.error("\(error.localizedDescription)")
        }
    }
}

#Preview {
    VStack {
        BillboardBannerView(advert: BillboardSamples.sampleDefaultAd)
        BillboardBannerView(advert: BillboardSamples.sampleDefaultAd, hideDismissButtonAndTimer: true)
    }
    .padding()
}
