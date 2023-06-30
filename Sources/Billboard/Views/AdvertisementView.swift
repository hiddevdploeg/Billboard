//
//  AdvertisementView.swift
//
//  Created by Hidde van der Ploeg on 27/06/2022.
//

import SwiftUI
import StoreKit

struct AdvertisementView: View {
    @Environment(\.dismiss) var dismiss
    
    let advert : BillboardAd
    
    var storeOverlay : SKOverlay {
        let config = SKOverlay.AppConfiguration(appIdentifier: advert.appStoreID, position: .bottom)
        let overlay = SKOverlay(configuration: config)
        return overlay
    }
    
    let scene = UIApplication.shared.connectedScenes
        .compactMap({ scene -> UIWindow? in
            (scene as? UIWindowScene)?.keyWindow
        })
        .first?
        .windowScene
    
    @State private var showPaywall : Bool = false
    @State private var counter = 15
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var canDismiss = false
    @State private var timerProgress : CGFloat = 0.0
    
    var body: some View {
        ZStack(alignment: .top) {

            if advert.isFullscreen {
                FullScreenAdView(advert: advert)
            } else {
                ViewThatFits(in: .horizontal) {
                    HStack {
                        Spacer()
                        AdvertisementImage(advert: advert)
                        VStack {
                            Spacer()
                            AdvertisementTextView(advert: advert)
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    VStack {
                        Spacer()
                        AdvertisementImage(advert: advert)
                        AdvertisementTextView(advert: advert)
                        Spacer()
                    }
                    
                }
                .background(backgroundView)
            }
            
            HStack {
                Button {
                    showPaywall.toggle()
                } label: {
                    Text("Remove Ads")
                        .font(.system(.footnote, design: .rounded))
                        .bold()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .tint(advert.cta)
                
                Spacer()
                
                
                // TimerView
                if canDismiss {
                    BillboardDismissButton()
                        .tint(advert.cta)
                } else {
                    #if DEBUG
                    BillboardDismissButton()
                        .tint(advert.cta)
                    #endif
                    ZStack {
                        Circle()
                            .stroke(advert.cta.opacity(0.2), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(advert.cta, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                            .animation(.linear(duration: 0.5), value: timerProgress)
                        Text("\(counter)")
                            .font(.system(.caption, design: .rounded).monospacedDigit().weight(.bold))
                            .rotationEffect(.degrees(90))
                    }
                    .rotationEffect(.degrees(-90))
                    .frame(width: 32, height: 32)
                }
                
            }
            .frame(height: 40)
            .padding()
        }
        .sheet(isPresented: $showPaywall, onDismiss: handlePaywall) {
            #warning("TODO: Paywall")
            Text("Paywall Goes here")
        }
        .background(advert.background.ignoresSafeArea())
        .onAppear {
            displayOverlay()
            #if os(iOS)
            haptics(.heavy)
            #endif
        }
        .onChange(of: timerProgress) { progress in
            if progress >= 1.0 {
                canDismiss = true
            }
        }
        .onReceive(timer) { _ in
            counter -= 1
            timerProgress += 0.066666666666
        }
        .onDisappear {
            dismissOverlay()
        }
    }
    
    private func dismissOverlay() {
        guard let scene else { return }
        SKOverlay.dismiss(in: scene)
    }
    
    private func displayOverlay() {
        guard let scene else { return }
        storeOverlay.present(in: scene)
    }
    
    
    @ViewBuilder
    var backgroundView : some View {
        if advert.transparentBG {
            
            CachedImage(url: advert.media.absoluteString, content: { phase in
                switch phase {
                case .success(let image):
                    ZStack {
                        advert.background
                            .ignoresSafeArea()
                        image
                            .resizable()
                            .opacity(0.1)
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 20)
                            .saturation(0.8)
                    }
                    
                    
                default:
                    Color(hex: advert.backgroundColor)
                        .ignoresSafeArea()
                }
            })
        }
    }
    
    
    
    func handlePaywall() {
        #warning("TODO: Provide way to remove ads")
//        if PremiumStore.shared.isActive {
            dismiss()
//        }
    }
}


struct AdvertisementTextView : View {
    let advert: BillboardAd
    
    var body: some View {
        VStack(spacing: 0) {
            Text(advert.title)
                .font(.system(.title2, design: .rounded, weight: .heavy))
            Text(advert.description)
                .font(.system(.body, design: .rounded))
                .padding(.top)
        }
        .multilineTextAlignment(.center)
        .foregroundColor(advert.text)
        .frame(maxWidth: 640)
        .padding()
    }
}

struct AdvertisementImage : View {
    let advert : BillboardAd
    
    var body: some View {
        CachedImage(url: advert.media.absoluteString, content: { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color(hex: advert.backgroundColor)
                    ProgressView()
                        .tint(Color(hex: advert.ctaColor))
                }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .frame(maxWidth: 640)
            default:
                ZStack {
                    Color(hex: advert.backgroundColor)
                    Image(systemName: "bolt.slash.fill")
                        .foregroundColor(Color(hex: advert.ctaColor))
                }
            }
        })
    }
}



//  Haptics+Ext.swift
//  Modum B.V.
//  Created by Hidde van der Ploeg on 18/11/2021.
//


#if os(iOS)
import UIKit

/// Plays a haptic with a single function
/// - Parameter style: Feedback style (e.g. .light)
func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let haptic = UIImpactFeedbackGenerator(style: style)
        haptic.impactOccurred()
}
#endif


struct BillboardDismissButton : View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Label("Dismiss Advertisement", systemImage: "xmark.circle.fill")
                .labelStyle(.iconOnly)
                .symbolRenderingMode(.hierarchical)
                .imageScale(.large)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .controlSize(.large)
        }
        .onAppear {
            #if os(iOS)
            haptics(.light)
            #endif
        }
    }
}
