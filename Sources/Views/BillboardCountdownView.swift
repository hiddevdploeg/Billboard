//
//  BillboardCountdownView.swift
//
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI

struct BillboardCountdownView: View {

    let advert: BillboardAd
    let totalDuration: TimeInterval
    @Binding var canDismiss: Bool

    @State private var seconds: Double = 15
    @State private var timerProgress: CGFloat = 0.0

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        #if os(tvOS)
            ZStack {
                Circle()
                    .stroke(
                        advert.tint.opacity(0.2),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))

                Circle()
                    .trim(from: 0, to: timerProgress)
                    .stroke(
                        advert.tint,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))

                Text("\(seconds, specifier: "%.0f")")
                    .font(.system(.caption, design: .rounded, weight: .heavy).monospacedDigit())
                    .rotationEffect(.degrees(90))
                    .minimumScaleFactor(0.5)
                    .animation(.default, value: seconds)
                    .transition(.identity)
                    .contentTransition(.numericText(value: seconds))
                    .onReceive(timer) { _ in
                        if seconds > 0 {
                            seconds -= 1
                        }
                    }
            }
            .foregroundColor(advert.tint)
            .rotationEffect(.degrees(-90))
            .frame(width: 64, height: 64)
            .onAppear {
                seconds = totalDuration
                withAnimation(.linear(duration: totalDuration)) {
                    timerProgress = 1.0
                }
            }
            .onChange(
                of: seconds,
                {
                    if seconds < 1 {
                        canDismiss = true
                    }
                })
        #else
            ZStack {
                Circle()
                    .stroke(
                        .quinary,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))

                Circle()
                    .trim(from: 0, to: timerProgress)
                    .stroke(
                        .primary,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))

                Text("\(seconds, specifier: "%.0f")")
                    .font(.system(.caption, design: .rounded, weight: .heavy).monospacedDigit())
                    .rotationEffect(.degrees(90))
                    .minimumScaleFactor(0.5)
                    .animation(.default, value: seconds)
                    .transition(.identity)
                    .contentTransition(.numericText(value: seconds))
                    .onReceive(timer) { _ in
                        if seconds > 0 {
                            seconds -= 1
                        }
                    }
            }
            #if os(visionOS)
                .foregroundStyle(.primary)
            #else
                .foregroundStyle(advert.tint)
            #endif
            .rotationEffect(.degrees(-90))
            .frame(width: 32, height: 32)
            .onAppear {
                seconds = totalDuration
                withAnimation(.linear(duration: totalDuration)) {
                    timerProgress = 1.0
                }
            }
            .onChange(
                of: seconds,
                {
                    if seconds < 1 {
                        canDismiss = true
                    }
                }
            )
            .onTapGesture {
                #if DEBUG
                    canDismiss = true
                #endif
            }
        #endif
    }
}

struct BillboardCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BillboardSamples.sampleDefaultAd.background.ignoresSafeArea()
            BillboardCountdownView(
                advert: BillboardSamples.sampleDefaultAd, totalDuration: 15.0,
                canDismiss: .constant(false))
        }
    }
}
