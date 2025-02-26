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
                Text("DailyFlow")
                    .font(.title2)
                    .foregroundStyle(Color.white)
                    .bold()

                Spacer()

                // Right side (notifications)
                Button(action: {
                    // Your action here
                }) {
                    Image(systemName: "bell")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .tint(.white)
                }
            }
            .padding(.trailing, 12)
            .padding(.leading, 20)
            .padding(.top, -5)
            .padding(.bottom, 15)
        }
        .background(AppColors.colorTwo)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
