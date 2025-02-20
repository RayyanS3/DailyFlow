//
//  ContentView.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-19.
//

import SwiftUI

// MARK: - Data Model
struct CardObject: Identifiable {
    let id = UUID()
    var name: String
    var dueDate: String
}

struct ContentView: View {
    @State private var tasks: [CardObject] = [
        CardObject(name: "Example Task 1", dueDate: "Tomorrow"),
        CardObject(name: "Example Task 2", dueDate: "Next Week")
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack {
                    // Scrollable list of cards
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(tasks) { card in
                                TaskCardView(card: card)
                            }
                        }
                        .padding(.top, 16)
                    }
                    Spacer()
                }

                // Floating "+" button at bottom-right
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Add a new card with default or generated values
                            let newCard = CardObject(
                                name: "Task #\(tasks.count + 1)",
                                dueDate: "No Date"
                            )
                            tasks.append(newCard)
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
    let card: CardObject

    // Tracks the card’s position as the user drags/swipes
    @State private var offset: CGSize = .zero

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)

            VStack(spacing: 8) {
                Text(card.name)
                    .font(.headline)
                Text("Due Date: \(card.dueDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        // Adjust card size as desired
        .frame(width: 375, height: 100)
        // Move the card based on the current drag offset
        .offset(x: offset.width, y: offset.height)
        // Attach a DragGesture that updates offset and checks final position
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    // Update offset as the user drags
                    offset = gesture.translation
                }
                .onEnded { gesture in
                    // Check if we swiped far enough to the right
                    if offset.width > 100 {
                        print("Right swiped: \(card.name)")
                        // In future, you might remove this card from the list or trigger another action
                    }
                    
                    // Animate back to original position
                    withAnimation {
                        offset = .zero
                    }
                }
        )
    }
}

#Preview {
    ContentView()
}
