//
//  DefaultAdView.swift
//  
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI

struct DefaultAdView : View {
    let advert : BillboardAd
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                Spacer()
                AdvertisementImageView(advert: advert)
                VStack {
                    Spacer()
                    AdvertisementTextView(advert: advert)
                    Spacer()
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                AdvertisementImageView(advert: advert)
                AdvertisementTextView(advert: advert)
                Spacer()
            }
            
        }
        .background(backgroundView)
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
    
    
}

struct DefaultAdView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultAdView(advert: BillboardSamples.sampleDefaultAd)
    }
}

