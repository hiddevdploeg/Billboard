//
//  BillboardDismissButton.swift
//
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI

struct BillboardDismissButton : View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            #if os(visionOS)
            Label("Dismiss advertisement", systemImage: "xmark")
                .labelStyle(.iconOnly)
            #else
            Label("Dismiss advertisement", systemImage: "xmark.circle.fill")
                .labelStyle(.iconOnly)
                .font(.compatibleSystem(.title2, design: .rounded, weight: .bold))
                .symbolRenderingMode(.hierarchical)
                .imageScale(.large)
                .controlSize(.large)
            #endif
        }
    }
}
