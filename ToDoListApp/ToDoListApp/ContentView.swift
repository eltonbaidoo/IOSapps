//
//  ContentView.swift
//  ToDoListApp
//
//  Created by Elton Baidoo on 2/25/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var newTaskTitle = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("New Task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        guard !newTaskTitle.isEmpty else { return }
                        viewModel.addTask(title: newTaskTitle)
                        newTaskTitle = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
                .padding()

                List {
                    ForEach(viewModel.tasks, id: \.objectID) { task in
                        HStack {
                            Button(action: {
                                viewModel.toggleTaskCompletion(task)
                            }) {
                                Image(systemName: (task.isCompleted == true) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .green : .gray)
                            }
                            Text(task.title ?? "Untitled Task")
                                .strikethrough(task.isCompleted, color: .gray)
                                .foregroundColor(task.isCompleted ? .gray : .primary)

                            if isMacOS() {
                                Spacer()
                                Button(action: {
                                    viewModel.deleteTask(task: task)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let taskToDelete = viewModel.tasks[index]
                            viewModel.deleteTask(task: taskToDelete)
                        }
                    }
                }
            }
            .navigationTitle("To-Do List")
            .toolbar {
                if !isMacOS() {
                    EditButton()
                }
            }
        }
    }

    private func isMacOS() -> Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
}
