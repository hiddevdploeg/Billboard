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
            BillboardAdInfoLabel(advert: advert)
            
            VStack(spacing: 6) {
                Text(advert.title)
                    .font(.system(.title2, design: .rounded, weight: .heavy))
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(advert.description)
                    .font(.system(.body, design: .rounded))
#if os(tvOS)
                if let appStoreLink = advert.appStoreLink {
                    appStoreLink.qrCodeView
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                        .frame(width: 200, height: 200)
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 0)
                        .padding(.top, 40)
                }
#endif
            }
        }
        .multilineTextAlignment(.center)
        .foregroundColor(advert.text)
        .frame(maxWidth: 640)
        .padding(.horizontal, 24)
        .padding(.bottom, 64)
    }
}

#Preview {
    BillboardTextView(advert: BillboardSamples.sampleDefaultAd)
}
