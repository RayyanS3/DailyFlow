//
//  ContentView.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-19.
//

import SwiftUI

struct ContentView: View {
    @State private var tasks: [CardObject] = TaskManager.sampleTasks()
    @State private var showingAddTaskView = false
    @State private var horizontalFilter: HorizontalFilter = .all

    var body: some View {
        TopNavBar()
        ZStack {

            VStack(spacing: 0) {
                
                VStack(alignment: .leading, spacing: 24) {
                    ProgressSummaryCard(tasks: tasks)
                        .padding(.horizontal)
                    
                    taskFilterSection
                    
                    ScrollView{
                        taskList
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 80)
                
            }
        }
        .sheet(isPresented: $showingAddTaskView) {
            AddTaskView { newTask in
                tasks.append(newTask)
            }
        }
        BottomNavBar(showingAddTaskView: $showingAddTaskView)
    }

    // MARK: - Task Filter Section
    private var taskFilterSection: some View {
        VStack(spacing: 8) {
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
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Task List
    private var taskList: some View {
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
}

// MARK: - Preview
#Preview {
    ContentView()
}
