//
//  AdvertisementImage.swift
//  
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI

struct BillboardImageView : View {
    let advert : BillboardAd
    
    var body: some View {
        CachedImage(url: advert.media.absoluteString) { phase in
            switch phase {
            case .empty:
                ZStack {
                    plainBackground
                    ProgressView()
                        .tint(advert.tint)
                }
                .accessibilityHidden(true)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 640)
                    .padding()
                    .accessibilityLabel(Text(advert.name))
                    .accessibilityAddTraits(.isImage)
            default:
                ZStack {
                    plainBackground
                    Image(systemName: "bolt.slash.fill")
                        .foregroundColor(advert.tint)
                }
                .accessibilityHidden(true)
                
            }
        }
    }
    
    private var plainBackground : some View {
        Rectangle()
            .fill(advert.background)
            .aspectRatio(1.0, contentMode: .fill)
            .frame(maxWidth: 640)
    }
}

struct BillboardImageView_Previews: PreviewProvider {
    static var previews: some View {
        BillboardImageView(advert: BillboardSamples.sampleFullScreenAd)
    }
}
