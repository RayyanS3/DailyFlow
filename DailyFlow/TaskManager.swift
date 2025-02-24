//
//  TaskManager.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-24.
//


import Foundation
import SwiftUI

struct TaskManager {
    // Sample tasks for demo
    static func sampleTasks() -> [CardObject] {
        return [
            CardObject(name: "UI Design", dueDate: "09:00 AM - 11:00 AM",
                       priority: "Medium", notes: "", isComplete: false),
            CardObject(name: "Web Development", dueDate: "11:30 AM - 12:30 PM",
                       priority: "High", notes: "Frontend improvements", isComplete: false),
            CardObject(name: "Office Meeting", dueDate: "02:00 PM - 03:00 PM",
                       priority: "Low", notes: "Discuss Q1 goals", isComplete: true),
            CardObject(name: "Dashboard Design", dueDate: "03:30 PM - 05:00 PM",
                       priority: "Medium", notes: "", isComplete: false)
        ]
    }

    // Filtering tasks based on selected filter
    static func filteredTasks(tasks: [CardObject], filter: HorizontalFilter) -> [CardObject] {
        switch filter {
        case .all:
            return tasks
        case .done:
            return tasks.filter { $0.isComplete }
        case .pending:
            return tasks.filter { !$0.isComplete }
        }
    }

    // Handling left swipe logic (snooze or mark incomplete)
    static func handleLeftSwipe(task: CardObject, tasks: inout [CardObject]) {
        if task.isComplete {
            markTaskIncomplete(task: task, tasks: &tasks)
        } else {
            snoozeTask(task: task, tasks: &tasks)
        }
    }

    // Mark a task as incomplete
    static func markTaskIncomplete(task: CardObject, tasks: inout [CardObject]) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isComplete = false
        }
    }

    // Snooze task (move to bottom of the list)
    static func snoozeTask(task: CardObject, tasks: inout [CardObject]) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            let snoozedTask = tasks.remove(at: index)
            tasks.append(snoozedTask)
        }
    }

    // Mark task as complete
    static func markTaskComplete(task: CardObject, tasks: inout [CardObject]) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isComplete = true
        }
    }

    // Get the icon for task priority
    static func iconForPriority(_ priority: String) -> Image {
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
}