//
//  TxtToDocApp.swift
//  TxtToDoc
//
//  Created by Elton Baidoo on 2/28/25.
//

import SwiftUI

@main
struct TxtToDocApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
