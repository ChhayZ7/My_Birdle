//
//  My_BirdleApp.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 5/11/2025.
//

import SwiftUI

@main
struct My_BirdleApp: App {
    // Initialise Core Data persistence controller
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // Inject managed object context into environment
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
