//
//  BillboardTextView.swift
//  
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI

struct BillboardTextView : View {
    let advert: BillboardAd
    
    var body: some View {
        VStack(spacing: 6) {
            Text(advert.title)
                .font(.system(.title2, design: .rounded, weight: .heavy))
            Text(advert.description)
                .font(.system(.body, design: .rounded))
        }
        .multilineTextAlignment(.center)
        .foregroundColor(advert.text)
        .frame(maxWidth: 640)
        .padding(.horizontal)
        .padding(.bottom, 64)
    }
}

struct BillboardTextView_Previews: PreviewProvider {
    static var previews: some View {
        BillboardTextView(advert: BillboardSamples.sampleFullScreenAd)
    }
}
