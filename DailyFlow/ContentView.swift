//
//  ContentView.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-19.
//

import SwiftUI

enum TaskLayoutMode{
    case list
    case card
}


struct ContentView: View {
    @State private var tasks: [CardObject] = TaskManager.sampleTasks()
    @State private var showingAddTaskView = false
    @State private var horizontalFilter: HorizontalFilter = .all
    @State private var layoutMode: TaskLayoutMode = .card

    var body: some View {
        TopNavBar()
        ProgressSummaryCard(tasks: tasks)
            .padding(.horizontal)
            .padding(.vertical, 8)
        
            taskFilterSection
            ScrollView{
                taskList
            }
            .padding(.top, 8)
            .padding(.bottom, 0)
            .sheet(isPresented: $showingAddTaskView) {
                AddTaskView { newTask in tasks.append(newTask)}
            }
        BottomNavBar(showingAddTaskView: $showingAddTaskView).ignoresSafeArea(edges: .bottom)

    }

    // MARK: - Task Filter Section
    private var taskFilterSection: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack {
                Text("Today’s Tasks:")
                    .font(.headline)

                Spacer()

                HStack(spacing: 16) {
                    ForEach(HorizontalFilter.allCases, id: \.self) { filter in
                        Button(action: { horizontalFilter = filter }) {
                            Text(filter.rawValue)
                                .font(.subheadline)
                                .foregroundColor(horizontalFilter == filter ? AppColors.colorTwo : .gray)
                        }
                    }
                }.padding(.trailing, 5)
                
                Button(action: {
                        layoutMode = (layoutMode == .list) ? .card : .list
                    }) {
                        Image(systemName: layoutMode == .list ? "square.grid.2x2.fill" : "list.bullet")
                            .font(.title2)
                            .foregroundColor(AppColors.colorTwo)
                    }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Task List
    private var taskList: some View {
        Group {
            if layoutMode == .list {
                listLayout
            } else {
                cardLayout
            }
        }
    }
    
    private var listLayout: some View {
        VStack(spacing: 12) {
            ForEach(TaskManager.filteredTasks(tasks: tasks, filter: horizontalFilter)) { task in
                SwipableTaskRow(
                    task: task,
                    icon: TaskManager.iconForPriority(task.priority),
                    onSwipeLeft: { _ in TaskManager.handleLeftSwipe(task: task, tasks: &tasks) },
                    onSwipeRight: { _ in TaskManager.markTaskComplete(task: task, tasks: &tasks) }
                )
                .padding(.horizontal)
            }
        }
    }
    
    private var cardLayout: some View {
        Group {
            if let firstTask = TaskManager.filteredTasks(tasks: tasks, filter: horizontalFilter).first {
                SwipeableTaskCard(
                    task: firstTask,
                    onSwipeLeft: { TaskManager.handleLeftSwipe(task: firstTask, tasks: &tasks) },
                    onSwipeRight: { TaskManager.markTaskComplete(task: firstTask, tasks: &tasks) }
                )
                .frame(height: 400)
                .padding()
            } else {
                // Display a blank card as a placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 300, height: 400)
                    .shadow(radius: 5)
                    .padding()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
