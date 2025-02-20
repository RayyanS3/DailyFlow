//
//  AppColors.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-19.
//

import SwiftUI

// MARK: - App Colors
// A simple struct holding your custom Color definitions.
// Adjust naming as you see fit.
struct AppColors {
    static let colorOne   = Color(hex: "427AA1")
    static let colorTwo   = Color(hex: "1D3557")
    static let colorThree = Color(hex: "A8DADC")
    static let colorFour  = Color(hex: "427AA1")
}

// MARK: - Hex Color Initializer
// Lets you create a SwiftUI Color from a hex code string.
extension Color {
    init(hex: String) {
        let r, g, b: CGFloat
        var hexColor = hex
        
        // Remove leading "#" if present
        if hexColor.hasPrefix("#") {
            hexColor.removeFirst()
        }
        
        // Ensure it’s 6 characters, then parse
        if hexColor.count == 6, let intVal = Int(hexColor, radix: 16) {
            r = CGFloat((intVal >> 16) & 0xFF) / 255.0
            g = CGFloat((intVal >> 8) & 0xFF) / 255.0
            b = CGFloat(intVal & 0xFF) / 255.0
            
            self = Color(red: r, green: g, blue: b)
        } else {
            // Fallback color if invalid hex
            self = Color.red
        }
    }
}
