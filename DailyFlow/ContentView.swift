//
//  ContentView.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background color fills entire screen
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                // Center the card vertically
                VStack {
                    Spacer()
                    TaskCardView()   // Our custom card
                    Spacer()
                }

                // Floating "+" button at bottom-right
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Handle new task creation here in future
                        }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("SwipeList")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Task Card View
struct TaskCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

            VStack(spacing: 8) {
                Text("Task Title")
                    .font(.headline)
                Text("Due Date: Tomorrow")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .frame(width: 300, height: 150)
    }
}

#Preview {
    ContentView()
}
