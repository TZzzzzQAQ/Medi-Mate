//
//  FontSizeMultiplierKey.swift
//  Mobile
//
//  Created by Lykheang Taing on 21/08/2024.
//

import Foundation
import SwiftUI

private struct FontSizeMultiplierKey: EnvironmentKey {
    static let defaultValue: CGFloat = 1.0
}

extension EnvironmentValues {
    var fontSizeMultiplier: CGFloat {
        get { self[FontSizeMultiplierKey.self] }
        set { self[FontSizeMultiplierKey.self] = newValue }
    }
}
