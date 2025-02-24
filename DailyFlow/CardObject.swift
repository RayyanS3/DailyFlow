//
//  CardObject.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-24.
//

import Foundation

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
