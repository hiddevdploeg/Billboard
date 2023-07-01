//
//  AdvertisementImage.swift
//  
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI

struct AdvertisementImageView : View {
    let advert : BillboardAd
    
    var body: some View {
        CachedImage(url: advert.media.absoluteString) { phase in
            switch phase {
            case .empty:
                ZStack {
                    advert.background
                    ProgressView()
                        .tint(advert.tint)
                }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 640)
                    .padding()
            default:
                ZStack {
                    Color(hex: advert.backgroundColor)
                    Image(systemName: "bolt.slash.fill")
                        .foregroundColor(advert.tint)
                }
            }
        }
    }
}

struct AdvertisementImageView_Previews: PreviewProvider {
    static var previews: some View {
        AdvertisementImageView(advert: BillboardSamples.sampleFullScreenAd)
    }
}
