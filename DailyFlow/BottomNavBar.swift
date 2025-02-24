//
//  BottomNavBar.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-24.
//


import SwiftUI

struct BottomNavBar: View {
    @Binding var showingAddTaskView: Bool

    var body: some View {
        Button(action: {
            showingAddTaskView = true
        }) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.title)
                .frame(width: 60, height: 60)
                .background(AppColors.colorTwo)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
    }
}
