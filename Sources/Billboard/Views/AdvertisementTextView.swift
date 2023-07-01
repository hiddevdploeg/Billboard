//
//  AdvertisementTextView.swift
//  
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI

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
        .padding(.horizontal)
        .padding(.bottom, 64)
    }
}

struct AdvertisementTextView_Previews: PreviewProvider {
    static var previews: some View {
        AdvertisementTextView(advert: BillboardSamples.sampleFullScreenAd)
    }
}
