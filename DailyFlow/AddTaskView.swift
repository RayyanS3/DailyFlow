//
//  AddTaskView.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-19.
//


import SwiftUI

struct AddTaskView: View {
    // Callback that passes the new card back to ContentView
    var onSave: (CardObject) -> Void
    
    // Fields the user can edit
    @State private var name: String = ""
    @State private var selectedDate: Date = Date()
    @State private var priority: String = "Medium"
    @State private var notes: String = ""
    
    @State private var category: String = "Work"
    @State private var estimatedDuration: Int = 60
    @State private var shouldRemind: Bool = false
    @State private var recurrence: String = "None"
    
    // For dismissing the sheet programmatically
    @Environment(\.dismiss) private var dismiss

    private let priorityOptions = ["Low", "Medium", "High"]
    private let categoryOptions = ["Work", "Personal", "Fitness", "Other"]
    private let recurrenceOptions = ["None", "Daily", "Weekly", "Monthly"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Name", text: $name)
                    
                    // Combined date + time picker
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
                
                Section(header: Text("Additional Settings")) {
                    Picker("Category", selection: $category) {
                        ForEach(categoryOptions, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    
                    Stepper("Est. Duration: \(estimatedDuration) min",
                            value: $estimatedDuration,
                            in: 15...240,
                            step: 15)
                    
                    Toggle("Set Reminder", isOn: $shouldRemind)
                    
                    Picker("Repeat", selection: $recurrence) {
                        ForEach(recurrenceOptions, id: \.self) { r in
                            Text(r).tag(r)
                        }
                    }
                }

                Section(header: Text("Notes (Optional)")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
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
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .short
                        
                        let newCard = CardObject(
                            name: name.isEmpty ? "Untitled Task" : name,
                            dueDate: dateFormatter.string(from: selectedDate),
                            priority: priority,
                            notes: notes
                        )
                        
                        onSave(newCard)
                        dismiss()
                    }
                }
            }
        }
    }
}
