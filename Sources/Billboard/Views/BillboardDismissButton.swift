//
//  BillboardDismissButton.swift
//
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI

public struct BillboardDismissButton : View {
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        Button {
            dismiss()
        } label: {
            Label("Dismiss advertisement", systemImage: "xmark.circle.fill")
                .labelStyle(.iconOnly)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .symbolRenderingMode(.hierarchical)
                .imageScale(.large)
                .controlSize(.large)
        }
    }
}
