//
//  QRCodeView.swift
//  Billboard
//
//  Created by Hidde van der Ploeg on 26/11/2024.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

public extension URL {
    /// A SwiftUI View that displays the URL as a QR code
    var qrCodeView: some View {
        QRCodeView(url: self)
    }
}

public struct QRCodeView: View {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    // Create a CIContext for rendering the QR code
    private let context = CIContext()
    
    // Create the QR code generator filter
    private var qrCodeGenerator: CIFilter {
        let filter = CIFilter.qrCodeGenerator()
        let data = url.absoluteString.data(using: .utf8)
        filter.setValue(data, forKey: "inputMessage")
        // You can adjust the correction level if needed
        // filter.setValue("H", forKey: "inputCorrectionLevel")
        return filter
    }
    
    // Generate the QR code image
    private var qrCodeImage: NSUIImage? {
        guard let outputImage = qrCodeGenerator.outputImage else { return nil }
        
        // Scale the image to a reasonable size
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: transform)
        
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }
        
        return NSUIImage(cgImage: cgImage)
    }
    
    public var body: some View {
        Group {
            if let image = qrCodeImage {
                Image(nsuiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("Failed to generate QR code")
                    .foregroundColor(.red)
            }
        }
    }
}
