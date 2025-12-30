//
//  NSUIImage.swift
//
//
//  Created by Andy Lin on 5/27/24.
//

import Foundation
import SwiftUI

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import SwiftUI

#if os(macOS)
typealias NSUIImage = NSImage
#else
typealias NSUIImage = UIImage
#endif

extension Image {
    init(nsuiImage: NSUIImage) {
        #if os(macOS)
        self.init(nsImage: nsuiImage)
        #else
        self.init(uiImage: nsuiImage)
        #endif
    }
}

#if os(macOS)
extension NSImage {
    convenience init(cgImage: CGImage) {
        self.init(cgImage: cgImage, size: .init(width: cgImage.width, height: cgImage.height))
    }
}
#endif
