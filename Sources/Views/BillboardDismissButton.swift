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
