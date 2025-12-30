//
//  BillboardDismissButton.swift
//
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI

struct BillboardDismissButton : View {
    @Environment(\.dismiss) var dismiss
    
    var label: some View {
#if os(visionOS)
        Label("Dismiss advertisement", systemImage: "xmark")
            .labelStyle(.iconOnly)
#else
        Label("Dismiss advertisement", systemImage: "xmark.circle.fill")
            .labelStyle(.iconOnly)
#if os(tvOS)
            .font(.system(.body, design: .rounded, weight: .bold))
#else
            .font(.system(.title2, design: .rounded, weight: .bold))
#endif
            .symbolRenderingMode(.hierarchical)
            .imageScale(.large)
#endif
    }
    
    var body: some View {
        if #available(iOS 26.0, tvOS 26.0, visionOS 26.0, macOS 26, *) {
            Button(role: .close) {
                dismiss()
            }
            .buttonBorderShape(.circle)
            #if !os(tvOS)
            .controlSize(.large)
            #endif
        } else {
            Button {
                dismiss()
            } label: {
                label
            }
            #if os(tvOS)
            .buttonBorderShape(.circle)
            #else
            .controlSize(.large)
            #endif
        }
       
    }
}
