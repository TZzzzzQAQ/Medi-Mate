//
//  Utlis.swift
//  Mobile
//
//  Created by Lykheang Taing on 13/08/2024.
//

import Foundation

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }

    static var exampleGrey = Color(hex: "FFFFFF")
    static var exampleLightGrey = Color(hex: "FFFFFF")
    static var examplePurple = Color(hex: "7D26FE")
    static var exampleBlue = Color(hex: "ADD8E6")
    
}
