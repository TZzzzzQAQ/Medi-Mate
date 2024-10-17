//
//  ScalableFont.swift
//  Mobile
//
//  Created by Lykheang Taing on 21/08/2024.
//

import Foundation
import SwiftUI

struct ScalableFont: ViewModifier {
    @Environment(\.fontSizeMultiplier) var fontSizeMultiplier
    let size: CGFloat
    let weight: Font.Weight
    let design: Font.Design

    func body(content: Content) -> some View {
        content
            .font(.system(size: size * fontSizeMultiplier, weight: weight, design: design))
    }
}

extension View {
    func scalableFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.modifier(ScalableFont(size: size, weight: weight, design: design))
    }
}
