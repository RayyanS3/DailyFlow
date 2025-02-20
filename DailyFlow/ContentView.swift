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
                // A subtle gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    // Scrollable list of cards
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(tasks) { card in
                                // Pass a closure to delete the card back to ContentView
                                TaskCardView(card: card) {
                                    // Remove this card from tasks array
                                    tasks.removeAll { $0.id == card.id }
                                }
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 16)
                    }
                    Spacer()
                }

                // Floating "+" button at bottom-right
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Add a new card
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
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
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
    // This closure lets us signal the parent view to delete this card
    let onDelete: () -> Void

    // Tracks the card’s position as the user drags/swipes
    @State private var offset: CGSize = .zero

    // Tracks whether the user has triggered the "pending delete" state
    @State private var isPendingDelete: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            // Left accent bar for style / priority cue
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.blue.opacity(0.2)) // subtle fill color
                .frame(width: 6)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.leading, 8)

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                // Red border & scale effect if card is pending deletion
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isPendingDelete ? Color.red : Color.clear, lineWidth: 3)
                )
                .scaleEffect(isPendingDelete ? 1.05 : 1.0)

            // Card Content
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(card.name)
                        .font(.headline)
                    HStack {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(card.dueDate)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding([.leading, .vertical], 12)

                Spacer()
            }
        }
        .frame(width: 350, height: 80)
        // Move the card based on the current horizontal drag offset only
        .offset(x: offset.width, y: offset.height)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    // Restrict movement to horizontal only
                    offset.width = gesture.translation.width
                    offset.height = 0
                }
                .onEnded { _ in
                    // Check if we swiped far enough to the right
                    if offset.width > 100 {
                        print("Right swiped: \(card.name)")
                        // In future, remove the card or perform another action
                    }
                    // Check if we swiped far enough to the left
                    else if offset.width < -100 {
                        print("Left swiped: \(card.name)")
                        // Handle left swipe action
                    }

                    // Animate card back to original position
                    withAnimation {
                        offset = .zero
                    }
                }
        )
        // On long press, highlight the card + show confirmation alert
        .onLongPressGesture {
            withAnimation {
                isPendingDelete = true
            }
        }
        // Confirmation Alert
        .alert("Confirm Deletion",
               isPresented: $isPendingDelete,
               actions: {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) {
                withAnimation {
                    isPendingDelete = false
                }
            }
        },
               message: {
            Text("Are you sure you want to delete this card?")
        })
    }
}

#Preview {
    ContentView()
}
