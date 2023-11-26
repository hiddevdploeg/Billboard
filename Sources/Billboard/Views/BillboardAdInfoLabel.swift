//
//  BillboardAdInfoLabel.swift
//  
//
//  Created by Hidde van der Ploeg on 03/07/2023.
//

import SwiftUI

struct BillboardAdInfoLabel: View {
    let advert : BillboardAd
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(advert.tint.opacity(0.15))
            Text("AD")
                .font(.system(size: 8, weight: .heavy, design: .rounded))
                .foregroundColor(advert.tint)
                .offset(x:0.5)
        }
        .frame(width: 22, height: 14)
        .accessibilityLabel(Text("Advertisement"))
    }
}

struct BillboardAdInfoLabel_Previews: PreviewProvider {
    static var previews: some View {
        BillboardAdInfoLabel(advert: BillboardSamples.sampleDefaultAd)
    }
}
