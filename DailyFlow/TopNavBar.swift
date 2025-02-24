//
//  TopNavBar.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-24.
//


import SwiftUI

struct TopNavBar: View {
    var body: some View {
        ZStack {
            HStack {
                Spacer()

                Text("DailyFlow")
                    .font(.headline)
                    .padding(.leading, 20)
                    .foregroundStyle(Color.white)
                    .offset(y: 10)

                Spacer()

                // Right side (notifications)
                Button(action: {
                    // Your action here
                }) {
                    Image(systemName: "bell")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .tint(.white)
                }
            }
            .padding(.horizontal, 40)
            .padding(.top, -20)
            .padding(.bottom, 20)
        }
        .background(LinearGradient(
            gradient: Gradient(colors: [
                AppColors.colorOne,
                AppColors.colorTwo,
                AppColors.colorFour
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
