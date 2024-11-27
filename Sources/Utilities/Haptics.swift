//
//  Haptics.swift
//
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import Foundation


#if os(iOS)
import UIKit

/// Plays a haptic with a single function
/// - Parameter style: Feedback style (e.g. .light)
func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let haptic = UIImpactFeedbackGenerator(style: style)
        haptic.impactOccurred()
}
#endif
