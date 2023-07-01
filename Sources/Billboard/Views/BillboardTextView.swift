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
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(advert.tint.opacity(0.15))
                Text("AD")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundColor(advert.tint)
                    .offset(x:0.5)
            }
            .frame(width: 26, height: 18)
            
            VStack(spacing: 6) {
                Text(advert.title)
                    .font(.system(.title2, design: .rounded, weight: .heavy))
                Text(advert.description)
                    .font(.system(.body, design: .rounded))
            }
        }
        .multilineTextAlignment(.center)
        .foregroundColor(advert.text)
        .frame(maxWidth: 640)
        .padding(.horizontal, 24)
        .padding(.bottom, 64)
    }
}

struct BillboardTextView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultAdView(advert: BillboardSamples.sampleDefaultAd)
    }
}
