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

struct BillboardImageView_Previews: PreviewProvider {
    static var previews: some View {
        BillboardImageView(advert: BillboardSamples.sampleFullScreenAd)
    }
}
