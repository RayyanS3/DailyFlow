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
    var priority: String
    var notes: String
}

// MARK: - Main Content View
struct ContentView: View {
    @State private var tasks: [CardObject] = [
        // Some sample tasks, you can start empty if you prefer:
        CardObject(name: "UI Design", dueDate: "09:00 AM - 11:00 AM", priority: "Medium", notes: ""),
        CardObject(name: "Web Development", dueDate: "11:30 AM - 12:30 PM", priority: "High", notes: "Frontend improvements"),
        CardObject(name: "Office Meeting", dueDate: "02:00 PM - 03:00 PM", priority: "Low", notes: "Discuss Q1 goals"),
        CardObject(name: "Dashboard Design", dueDate: "03:30 PM - 05:00 PM", priority: "Medium", notes: "")
    ]
    
    // Controls whether the sheet is presented
    @State private var showingAddTaskView = false
    
    var body: some View {
        ZStack {
            // Background color for the entire screen
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top navigation bar
                topNavBar
                
                // Scrollable Content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Progress Summary Card
                        progressSummaryCard
                            .padding(.horizontal)
                        
                        // “Today’s Task” Section
                        VStack(spacing: 16) {
                            HStack {
                                Text("Today’s Task")
                                    .font(.headline)
                                Spacer()
                                Button("See All") {
                                    // Action for 'See All' tasks (optional)
                                }
                                .font(.subheadline)
                            }
                            .padding(.horizontal)
                            
                            // Swipable list of tasks
                            VStack(spacing: 12) {
                                ForEach(tasks) { task in
                                    SwipableTaskRow(
                                        task: task,
                                        icon: iconForPriority(task.priority),
                                        onSwipeLeft: { swipedTask in
                                            // Example: handle left swipe (e.g. snooze)
                                            print("Left swipe on \(swipedTask.name)")
                                        },
                                        onSwipeRight: { swipedTask in
                                            // Example: handle right swipe (e.g. mark completed)
                                            print("Right swipe on \(swipedTask.name)")
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 80)  // extra space for bottom bar
                }
                
                // Bottom Navigation Bar
                bottomNavBar
            }
        }
        // Presents the AddTaskView as a sheet
        .sheet(isPresented: $showingAddTaskView) {
            AddTaskView { newTask in
                tasks.append(newTask)
            }
        }
    }
    
    // MARK: - Top Nav Bar
    private var topNavBar: some View {
        ZStack {
            HStack {
                Button(action: {
                    // Action for profile (e.g., open a user profile screen)
                }) {
                    Image("user-profile-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                }
                Spacer()

                Text("Homepage")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    // Action for notifications
                }) {
                    Image("gradient-outline-bell")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 40)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, -10)
            .padding(.bottom, 10)
        }
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    // MARK: - Progress Summary Card
    private var progressSummaryCard: some View {
        ZStack(alignment: .topLeading) {
            // Use your custom gradient
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            AppColors.colorOne,
                            AppColors.colorTwo,
                            AppColors.colorFour
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 140)

            VStack(alignment: .leading, spacing: 8) {
                Text("Today’s progress summary")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))

                Text("\(tasks.count) Tasks")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)

                // Example progress info (currently static 0.4 = 40%)
                HStack(spacing: 8) {
                    ProgressView(value: 0.4)
                        .tint(.white)
                        .frame(width: 120)
                    Text("40%")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding(.leading, 16)
            .padding(.top, 16)
        }
    }
    
    // MARK: - Icon for Priority
    private func iconForPriority(_ priority: String) -> Image {
        switch priority.lowercased() {
            case "high":   return Image(.rocketHigh)
            case "medium": return Image(.baloonMed)
            case "low":    return Image(.paperLow)
            default:       return Image(.paperLow)
        }
    }
    
    // MARK: - Bottom Nav Bar
    private var bottomNavBar: some View {
        ZStack(alignment: .bottom) {
            // White background bar
            HStack {
                Button(action: {
                    // Home
                }) {
                    Image(systemName: "house.fill")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    // Profile
                }) {
                    Image(systemName: "person.crop.circle")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 40)
            .frame(height: 56)
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: -2)
            
            // Center floating Add button
            VStack {
                Button(action: {
                    showingAddTaskView = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
            }
            // Position the button slightly above the bar
            .offset(y: -23)
        }
    }
}

// MARK: - SwipableTaskRow
/// A row that can be dragged left or right.
/// On a successful threshold swipe, calls onSwipeLeft or onSwipeRight.
struct SwipableTaskRow: View {
    let task: CardObject
    let icon: Image
    
    // Optional callbacks for each swipe direction.
    var onSwipeLeft: (CardObject) -> Void
    var onSwipeRight: (CardObject) -> Void
    
    // Track the card’s horizontal offset as the user drags
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            // Background shape for the card
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)

            // Actual row content
            HStack {
                // Left icon
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .overlay(
                        icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.name)
                        .font(.subheadline)
                    Text(task.dueDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
        }
        // Constrain the overall card size
        .frame(height: 80)
        // Offset the card horizontally based on drag
        .offset(x: offset.width, y: 0)
        // Add a drag gesture restricted to horizontal movement
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset.width = gesture.translation.width
                }
                .onEnded { _ in
                    // Check thresholds for a swipe
                    if offset.width > 100 {
                        // Swiped Right
                        onSwipeRight(task)
                    } else if offset.width < -100 {
                        // Swiped Left
                        onSwipeLeft(task)
                    }
                    
                    // Animate back to center
                    withAnimation {
                        offset = .zero
                    }
                }
        )
    }
}

// MARK: - Add Task View
struct AddTaskView: View {
    var onSave: (CardObject) -> Void
    
    // Fields the user can edit
    @State private var name: String = ""
    @State private var selectedDate: Date = Date()
    @State private var priority: String = "Medium"
    @State private var notes: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    private let priorityOptions = ["Low", "Medium", "High"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Name", text: $name)
                    
                    // Example: Date & time
                    DatePicker("Due Date & Time",
                               selection: $selectedDate,
                               displayedComponents: [.date, .hourAndMinute])
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(priorityOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Notes (Optional)")) {
                    TextEditor(text: $notes)
                        .frame(height: 120)
                }
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        formatter.timeStyle = .short
                        
                        let newTask = CardObject(
                            name: name.isEmpty ? "Untitled Task" : name,
                            dueDate: formatter.string(from: selectedDate),
                            priority: priority,
                            notes: notes
                        )
                        onSave(newTask)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
