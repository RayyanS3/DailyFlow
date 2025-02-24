//
//  ContentView.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-19.
//

//
//  ContentView.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-19.
//

import SwiftUI

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
                        // Updated progress summary card
                        progressSummaryCard
                            .padding(.horizontal)
                        
                        // "Today’s Tasks:" label + horizontal filter row
                        VStack(spacing: 8) {
                            HStack {
                                Text("Today’s Tasks:")
                                    .font(.headline)
                                
                                Spacer()
                                
                                // Horizontal filter row
                                HStack(spacing: 16) {
                                    ForEach(HorizontalFilter.allCases, id: \.self) { filter in
                                        Button(action: {
                                            horizontalFilter = filter
                                        }) {
                                            Text(filter.rawValue)
                                                .font(.subheadline)
                                                .foregroundColor(
                                                    horizontalFilter == filter
                                                    ? AppColors.colorTwo
                                                    : .gray
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
                
                
                Spacer()

                Text("DailyFlow")
                    .font(.headline)
                    .padding(.leading, 20)
                    .foregroundStyle(Color.white)
                    .offset(y: 10)
                
                Spacer()
                
                // Right side (notifications)
                Button(action: {
                    // your action
                }) {
                    Image(systemName: "bell")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .tint(.white)
                }
            }
            .padding(.horizontal, 40)
            .padding(.top, -20)
            .padding(.bottom, 20)
        }
        .background(LinearGradient(
            gradient: Gradient(colors: [
                AppColors.colorOne,
                AppColors.colorTwo,
                AppColors.colorFour
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    // MARK: - RingView (Donut Chart for Progress)
    struct RingView: View {
        let progress: Double        // 0.0 → 1.0
        let lineWidth: CGFloat
        let foregroundColor: Color
        let backgroundColor: Color

        var body: some View {
            ZStack {
                Circle()
                    .stroke(
                        backgroundColor,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                Circle()
                    .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                    .stroke(
                        foregroundColor,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
            }
        }
    }

    // MARK: - Enhanced Progress Summary Card
    private var progressSummaryCard: some View {
        let total   = tasks.count
        let done    = tasks.filter { $0.isComplete }.count
        let pending = total - done
        let ratio   = completionRatio // e.g., done/total

        return ZStack(alignment: .topLeading) {
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
                .frame(height: 180) // a bit taller to fit extra stats

            VStack(alignment: .leading, spacing: 12) {
                Text("Today’s progress summary")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.bottom, 5)
                HStack(){
                    HStack(spacing: 22) {
                        // Donut chart
                        ZStack {
                            RingView(
                                progress: ratio,
                                lineWidth: 8,
                                foregroundColor: .white,
                                backgroundColor: .white.opacity(0.3)
                            )
                            .frame(width: 70, height: 70)
                            
                            // Show % in the center
                            Text("\(Int(ratio * 100))%")
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                        
                        // Stats breakdown
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Total: ")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.8))
                                Text("\(total)")
                                    .font(.footnote).bold()
                                    .foregroundColor(.white)
                            }
                            HStack {
                                Text("Done: ")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.8))
                                Text("\(done)")
                                    .font(.footnote).bold()
                                    .foregroundColor(.white)
                            }
                            HStack {
                                Text("Pending: ")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.8))
                                Text("\(pending)")
                                    .font(.footnote).bold()
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // your action
                    }) {
                        Image("userImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .tint(.white)
                            .padding(.horizontal, 35)
                            .clipShape(.circle)
                    }
                }.buttonStyle(WhiteOutlineCircleButtonStyle())

                Divider()
                    .background(Color.white.opacity(0.3))
                    .padding(.vertical, 4)

                Text("Tasks completed this week: 12") // Placeholder
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.9))
                    .offset(y: -3)
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

// MARK: - Preview
#Preview {
    ContentView()
}
