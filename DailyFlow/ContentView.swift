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

// MARK: - Horizontal Filter Enum
enum HorizontalFilter: String, CaseIterable {
    case all = "All"
    case done = "Done"
    case pending = "Pending"
}

struct ContentView: View {
    // Sample tasks
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
    
    // Controls the presentation of the "Add Task" sheet
    @State private var showingAddTaskView = false
    
    // Tracks which filter is currently selected in the horizontal row
    @State private var horizontalFilter: HorizontalFilter = .all

    var body: some View {
        ZStack {
            // Background color
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top navigation bar (profile, title, notifications)
                topNavBar
                
                // Main scrollable area
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Progress summary card
                        progressSummaryCard
                            .padding(.horizontal)
                        
                        // "Today’s Task" + "See All" + horizontal filter
                        VStack(spacing: 8) {
                            // Header Row
                            HStack {
                                Text("Today’s Tasks:")
                                    .font(.headline)
                                
                                Spacer()
                                
                                HStack(spacing: 16) {
                                    ForEach(HorizontalFilter.allCases, id: \.self) { filter in
                                        Button(action: {
                                            horizontalFilter = filter
                                        }) {
                                            Text(filter.rawValue)
                                                .font(.subheadline)
                                                .foregroundColor(
                                                    horizontalFilter == filter ? .blue : .gray
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                               
                            }
                            .padding(.horizontal)
                            

                        }
                        
                        // Vertical list of filtered tasks
                        VStack(spacing: 12) {
                            ForEach(filteredTasks()) { task in
                                SwipableTaskRow(
                                    task: task,
                                    icon: iconForPriority(task.priority),
                                    onSwipeLeft: { swipedTask in
                                        handleLeftSwipe(swipedTask)
                                    },
                                    onSwipeRight: { swipedTask in
                                        markTaskComplete(swipedTask)
                                    }
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 80) // Space for bottom nav bar
                }
                
                // Bottom bar (Home, Profile, Add Task button in center)
                bottomNavBar
            }
        }
        // Sheet for adding a new task
        .sheet(isPresented: $showingAddTaskView) {
            AddTaskView { newTask in
                tasks.append(newTask)
            }
        }
    }
    
    // MARK: - Filtering Logic
    private func filteredTasks() -> [CardObject] {
        switch horizontalFilter {
        case .all:
            return tasks
        case .done:
            return tasks.filter { $0.isComplete }
        case .pending:
            return tasks.filter { !$0.isComplete }
        }
    }
    
    // MARK: - Left Swipe Logic
    private func handleLeftSwipe(_ swipedTask: CardObject) {
        // If task is complete, mark incomplete. Otherwise, "snooze" to bottom.
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
        if let index = tasks.firstIndex(where: { $0.id == swipedTask.id }) {
            let snoozedTask = tasks.remove(at: index)
            tasks.append(snoozedTask)
        }
    }
    
    // MARK: - Right Swipe Logic
    private func markTaskComplete(_ swipedTask: CardObject) {
        if let index = tasks.firstIndex(where: { $0.id == swipedTask.id }) {
            tasks[index].isComplete = true
        }
    }
    
    // MARK: - Top Navigation Bar
    private var topNavBar: some View {
        ZStack {
            HStack {
                // Left side (profile)
                Button(action: {
                    // your action
                }) {
                    Image(systemName: "person.crop.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .tint(.white)
                }
                
                Spacer()

                Text("DailyFlow")
                    .font(.headline)
                    .padding(.top, 10)
                    .foregroundStyle(Color.white)
                
                Spacer()
                
                // Right side (notifications)
                Button(action: {
                    // your action
                }) {
                    Image(systemName: "bell.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35 , height: 35)
                        .tint(.white)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, -15)
            .padding(.bottom, 15)
        }
        .background(AppColors.colorTwo)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    // MARK: - Progress Summary Card
    private var progressSummaryCard: some View {
        ZStack(alignment: .topLeading) {
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
                
                // Example: dynamic ratio
                HStack(spacing: 8) {
                    ProgressView(value: completionRatio)
                        .tint(.white)
                        .frame(width: 120)
                    Text("\(Int(completionRatio * 100))%")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding(.leading, 16)
            .padding(.top, 16)
        }
    }
    
    // MARK: - Completion Ratio
    private var completionRatio: Double {
        guard !tasks.isEmpty else { return 0 }
        let completedCount = tasks.filter { $0.isComplete }.count
        return Double(completedCount) / Double(tasks.count)
    }
    
    // MARK: - Icon for Priority
    private func iconForPriority(_ priority: String) -> Image {
        switch priority.lowercased() {
        case "high":
            return Image("rocketHigh")
        case "medium":
            return Image("baloonMed")
        case "low":
            return Image("paperLow")
        default:
            return Image("paperLow")
        }
    }
    
    // MARK: - Bottom Navigation Bar
    private var bottomNavBar: some View {
        ZStack(alignment: .bottom) {
            
            
            // Center Add Task button
            VStack {
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
    }
}

// MARK: - SwipableTaskRow
struct SwipableTaskRow: View {
    let task: CardObject
    let icon: Image
    
    var onSwipeLeft: (CardObject) -> Void
    var onSwipeRight: (CardObject) -> Void
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)

            HStack {
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
                    if offset.width > 100 {
                        onSwipeRight(task)
                    } else if offset.width < -100 {
                        onSwipeLeft(task)
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
