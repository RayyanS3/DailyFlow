//
//  AddTaskView.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-24.
//

import SwiftUI

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
