//
//  Font+iOS15.swift
//  
//
//  Created by Engin Kurutepe on 04.07.23.
//

import SwiftUI

extension Font {
    static func compatibleSystem(_ style: TextStyle, design: Design?, weight: Weight?) -> Font {
        if #available(iOS 16.0, *) {
            return .system(style, design: design, weight: weight)
        } else {
            return .system(style, design: design ?? .default).weight(weight ?? .regular)
        }
    }
}
