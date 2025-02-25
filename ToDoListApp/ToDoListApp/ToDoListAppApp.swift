//
//  ToDoListAppApp.swift
//  ToDoListApp
//
//  Created by Elton Baidoo on 2/25/25.
//

import SwiftUI

@main
struct ToDoListAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
