//
//  DefaultAdView.swift
//
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI

struct DefaultAdView: View {
    let advert: BillboardAd

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                #if os(tvOS)
                    Spacer()
                    VStack {
                        Spacer()
                        BillboardTextView(advert: advert)
                        Spacer()
                    }
                    BillboardImageView(advert: advert)
                    Spacer()
                #else
                    Spacer()
                    BillboardImageView(advert: advert)

                    VStack {
                        Spacer()
                        BillboardTextView(advert: advert)
                        Spacer()
                    }
                    Spacer()
                #endif

            }

            VStack {
                Spacer()
                BillboardImageView(advert: advert)
                BillboardTextView(advert: advert)
                Spacer()
            }

        }
        .background {
            backgroundView
        }
    }

    @ViewBuilder
    var backgroundView: some View {
        if advert.transparent {
            CachedImage(
                url: advert.media.absoluteString,
                content: { phase in
                    switch phase {
                    case .success(let image):
                        ZStack {
                            advert.background
                                .ignoresSafeArea()
                                #if os(visionOS)
                                    .opacity(0.75)
                                #endif
                            image
                                .resizable()
                                .opacity(0.1)
                                .aspectRatio(contentMode: .fill)
                                .blur(radius: 15)
                                .saturation(0.8)
                        }

                    default:
                        advert.background
                            .ignoresSafeArea()

                    }
                })
        }
    }

}

#Preview {
    DefaultAdView(advert: BillboardSamples.sampleDefaultAd)
}
