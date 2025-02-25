//
//  TaskViewModel.swift
//  ToDoListApp
//
//  Created by Elton Baidoo on 2/25/25.
//

import CoreData
import SwiftUI

class TaskViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var tasks: [TodoItem] = []
    
    init() {
        container = NSPersistentContainer(name: "ToDoListApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
        fetchTasks()
    }
    
    func fetchTasks() {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        do {
            tasks = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    
    func addTask(title: String) {
        let newTask = TodoItem(context: container.viewContext)
        newTask.title = title
        newTask.isCompleted = false  // ✅ Default is set in Core Data & Code
        saveContext()
    }
    
    func toggleTaskCompletion(_ task: TodoItem) {
        task.isCompleted.toggle()
        saveContext()
    }
    
    func deleteTask(task: TodoItem) {
        container.viewContext.delete(task)
        saveContext()
    }
    
    func saveContext() {
        do {
            try container.viewContext.save()
            fetchTasks()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
