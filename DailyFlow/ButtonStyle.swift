//
//  ButtonStyle.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-24.
//

import SwiftUI

/// A button style that draws a white circular outline and dims on press.
struct WhiteOutlineCircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Slightly shrink and dim when pressed
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.75 : 1.0)
            // White circular outline
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2).opacity(0.75)
            )
    }
}
