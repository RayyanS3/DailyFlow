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
    var priority: String   // For example: "Low", "Medium", "High"
    var notes: String
}

struct ContentView: View {
    @State private var tasks: [CardObject] = [
        CardObject(name: "Example Task 1", dueDate: "Tomorrow",
                   priority: "Medium", notes: ""),
        CardObject(name: "Example Task 2", dueDate: "Next Week",
                   priority: "High", notes: "Finish slides for presentation")
    ]
    
    // This will toggle our sheet
    @State private var showingAddTaskView = false

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
                            showingAddTaskView = true
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
            // Present the AddTaskView as a sheet
            .sheet(isPresented: $showingAddTaskView) {
                AddTaskView { newCard in
                    // Append the newly created card
                    tasks.append(newCard)
                }
            }
        }
    }
}

// MARK: - Task Card View (Unchanged)
struct TaskCardView: View {
    let card: CardObject
    let onDelete: () -> Void

    @State private var offset: CGSize = .zero
    @State private var isPendingDelete: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 6)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.leading, 8)

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isPendingDelete ? Color.red : Color.clear, lineWidth: 3)
                )
                .scaleEffect(isPendingDelete ? 1.05 : 1.0)

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
                Text("Priority: \(card.priority)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if !card.notes.isEmpty {
                    Text("Notes: \(card.notes)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .padding([.leading, .vertical], 12)
            .padding(.leading, 12)

        }
        .frame(width: 350, height: 120)
        .offset(x: offset.width, y: 0)   // Lock vertical offset to 0
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset.width = gesture.translation.width
                }
                .onEnded { _ in
                    if offset.width > 100 {
                        print("Right swiped: \(card.name)")
                        // Potentially remove or mark as done
                    } else if offset.width < -100 {
                        print("Left swiped: \(card.name)")
                        // Potentially snooze or do something else
                    }
                    withAnimation {
                        offset = .zero
                    }
                }
        )
        // Long press to highlight + show confirm alert
        .onLongPressGesture {
            withAnimation {
                isPendingDelete = true
            }
        }
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
        }, message: {
            Text("Are you sure you want to delete this task?")
        })
    }
}

#Preview {
    ContentView()
}
