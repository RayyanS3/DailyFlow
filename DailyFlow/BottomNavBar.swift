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
        // A full-width button with a plus icon and "Add new task" text
        Button(action: {
            showingAddTaskView = true
        }) {
            HStack(spacing: 10) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(AppColors.colorTwo)
                    .background(.white)
                    .clipShape(Circle())
                Text("Add new task")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(AppColors.colorTwo)      // Your custom color
            .cornerRadius(40)                    // Round the corners
        }.padding(.vertical, -34)
    }
}

