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
                        .frame(width: 30, height: 30)
                        .tint(.white)
                }
            }
            .padding(.trailing, 30)
            .padding(.leading, 23)
            .padding(.top, -25)
            .padding(.bottom, 15)
        }
        .background(AppColors.colorTwo)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
