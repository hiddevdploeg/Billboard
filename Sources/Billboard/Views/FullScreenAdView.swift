//
//  FullScreenAdView.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import SwiftUI

struct FullScreenAdView : View {
    let advert : BillboardAd
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                AdvertisementTextView(advert: advert)
                    .padding(.bottom, 40)
                Spacer()
            }
        }
        .background(
            ZStack {
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
                            .aspectRatio(contentMode: .fill)
                            .ignoresSafeArea(.all)
                    default:
                        ZStack {
                            Color(hex: advert.backgroundColor)
                            Image(systemName: "bolt.slash.fill")
                                .foregroundColor(Color(hex: advert.ctaColor))
                        }
                    }
                })
                LinearGradient(colors: [advert.background, advert.background.opacity(0.1)], startPoint: .bottom, endPoint: .top).ignoresSafeArea(.all)
            }
            
        )
    }
}

struct FullScreenAdView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenAdView(advert: BillboardConstants.sampleFullscreenAd)
    }
}
