//
//  BillboardCountdownView.swift
//
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI

public struct BillboardCountdownView : View {
    
    let advert : BillboardAd
    let totalDuration : TimeInterval
    @Binding var canDismiss : Bool
    
    
    @State private var seconds : Int = 15
    @State private var timerProgress : CGFloat = 0.0
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(advert.tint.opacity(0.2), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            Circle()
                .trim(from: 0, to: timerProgress)
                .stroke(advert.tint, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))

            Text("\(seconds)")
                .font(.system(.caption, design: .rounded, weight: .bold)).monospacedDigit()
                .rotationEffect(.degrees(90))
                .minimumScaleFactor(0.5)
                .onReceive(timer) { _ in
                    if seconds > 0 {
                        seconds -= 1
                    }
                }
        }
        .foregroundColor(advert.tint)
        .rotationEffect(.degrees(-90))
        .frame(width: 32, height: 32)
        .onAppear {
            seconds = Int(totalDuration)
            withAnimation(.linear(duration: totalDuration)) {
                timerProgress = 1.0
            }
        }
        .onChange(of: seconds) { _ in
            if seconds < 1 {
                canDismiss = true
            }
        }
        .onTapGesture {
            #if DEBUG
            canDismiss = true
            #endif
        }
    }
}


struct BillboardCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BillboardSamples.sampleDefaultAd.background.ignoresSafeArea()
            BillboardCountdownView(advert: BillboardSamples.sampleDefaultAd, totalDuration: 15.0, canDismiss: .constant(false))
        }
    }
}
