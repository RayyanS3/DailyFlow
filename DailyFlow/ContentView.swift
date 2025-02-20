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
    
    // Tracks if the task is complete or not
    var isComplete: Bool = false
}

// MARK: - Task Filter Enum
enum TaskFilter: String, CaseIterable {
    case all = "All"
    case complete = "Complete"
    case incomplete = "Incomplete"
}

// MARK: - Main Content View
struct ContentView: View {
    // Sample tasks to demonstrate filtering & logic
    @State private var tasks: [CardObject] = [
        CardObject(name: "UI Design", dueDate: "09:00 AM - 11:00 AM",
                   priority: "Medium", notes: "", isComplete: false),
        CardObject(name: "Web Development", dueDate: "11:30 AM - 12:30 PM",
                   priority: "High", notes: "Frontend improvements", isComplete: false),
        CardObject(name: "Office Meeting", dueDate: "02:00 PM - 03:00 PM",
                   priority: "Low", notes: "Discuss Q1 goals", isComplete: true),
        CardObject(name: "Dashboard Design", dueDate: "03:30 PM - 05:00 PM",
                   priority: "Medium", notes: "", isComplete: false)
    ]
    
    // Controls whether the "Add Task" sheet is shown
    @State private var showingAddTaskView = false
    
    // Tracks which filter is currently selected
    @State private var selectedFilter: TaskFilter = .all
    
    var body: some View {
        ZStack {
            // Background color
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                topNavBar
                
                // Main scrollable area
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Gradient summary card
                        progressSummaryCard
                            .padding(.horizontal)
                        
                        // Filter Picker + Task Rows
                        VStack(spacing: 16) {
                            filterSegmentedControl
                                .padding(.horizontal)
                            
                            // Swipable list of tasks
                            VStack(spacing: 12) {
                                ForEach(filteredTasks()) { task in
                                    SwipableTaskRow(
                                        task: task,
                                        icon: iconForPriority(task.priority),
                                        onSwipeLeft: { swipedTask in
                                            handleLeftSwipe(swipedTask)
                                        },
                                        onSwipeRight: { swipedTask in
                                            // Mark as complete (unchanged)
                                            markTaskComplete(swipedTask)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 80)  // extra space for bottom nav bar
                }
                
                // Bottom Navigation bar with a center add button
                bottomNavBar
            }
        }
        // Present AddTaskView as a sheet
        .sheet(isPresented: $showingAddTaskView) {
            AddTaskView { newTask in
                tasks.append(newTask)
            }
        }
    }
    
    // MARK: - Logic for Left Swipe
    private func handleLeftSwipe(_ swipedTask: CardObject) {
        // If the task is already complete, mark it incomplete.
        // Otherwise, move (snooze) it to the bottom.
        if swipedTask.isComplete {
            markTaskIncomplete(swipedTask)
        } else {
            snoozeTask(swipedTask)
        }
    }
    
    private func markTaskIncomplete(_ swipedTask: CardObject) {
        if let index = tasks.firstIndex(where: { $0.id == swipedTask.id }) {
            tasks[index].isComplete = false
        }
    }
    
    private func snoozeTask(_ swipedTask: CardObject) {
        // Move the swiped task to the bottom of the list
        if let index = tasks.firstIndex(where: { $0.id == swipedTask.id }) {
            let snoozedTask = tasks.remove(at: index)
            tasks.append(snoozedTask)
        }
    }
    
    // MARK: - Filtered Tasks
    private func filteredTasks() -> [CardObject] {
        switch selectedFilter {
        case .all:
            return tasks
        case .complete:
            return tasks.filter { $0.isComplete }
        case .incomplete:
            return tasks.filter { !$0.isComplete }
        }
    }
    
    // MARK: - Mark Task Complete (Right Swipe)
    private func markTaskComplete(_ swipedTask: CardObject) {
        // Find it in tasks and set isComplete = true
        if let index = tasks.firstIndex(where: { $0.id == swipedTask.id }) {
            tasks[index].isComplete = true
        }
    }
    
    // MARK: - Segmented Control
    private var filterSegmentedControl: some View {
        Picker("TaskFilter", selection: $selectedFilter) {
            ForEach(TaskFilter.allCases, id: \.self) { filterCase in
                Text(filterCase.rawValue).tag(filterCase)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    // MARK: - Top Navigation Bar
    private var topNavBar: some View {
        ZStack {
            HStack {
                // Profile (left side)
                Button(action: {
                    // your action
                }) {
                    Image("user-profile-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                }
                
                Spacer()

                // Title
                Text("Homepage")
                    .font(.headline)
                
                Spacer()
                
                // Notifications (right side)
                Button(action: {
                    // your action
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
            // Multi-stop gradient
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
                
                // Example progress info (static 0.4 = 40%)
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
    
    // MARK: - Determine Icon for Priority
    private func iconForPriority(_ priority: String) -> Image {
        switch priority.lowercased() {
        case "high":
            return Image("rocketHigh")   // Ensure rocketHigh is in Assets.xcassets
        case "medium":
            return Image("baloonMed")    // Ensure baloonMed is in Assets.xcassets
        case "low":
            return Image("paperLow")     // Ensure paperLow is in Assets.xcassets
        default:
            return Image("paperLow")
        }
    }
    
    // MARK: - Bottom Navigation Bar
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
            .offset(y: -23)
        }
    }
}

// MARK: - SwipableTaskRow
/// Displays a row that can be swiped left or right to trigger actions.
struct SwipableTaskRow: View {
    let task: CardObject
    let icon: Image
    
    // Callbacks for each swipe direction
    var onSwipeLeft: (CardObject) -> Void
    var onSwipeRight: (CardObject) -> Void
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)

            HStack {
                // Left icon area
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
                
                // If the task is complete, show a checkmark
                if task.isComplete {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
        }
        .frame(height: 80)
        // Horizontal offset for swiping
        .offset(x: offset.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset.width = gesture.translation.width
                }
                .onEnded { _ in
                    // Check for threshold swipes
                    if offset.width > 100 {
                        onSwipeRight(task)     // e.g., mark complete
                    } else if offset.width < -100 {
                        onSwipeLeft(task)      // handle left logic
                    }
                    withAnimation {
                        offset = .zero
                    }
                }
        )
    }
}

// MARK: - AddTaskView
struct AddTaskView: View {
    // Callback that passes the new card back to ContentView
    var onSave: (CardObject) -> Void
    
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
                    
                    DatePicker("Due Date & Time",
                               selection: $selectedDate,
                               displayedComponents: [.date, .hourAndMinute])
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(priorityOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
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
