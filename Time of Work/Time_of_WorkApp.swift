//
//  Time_of_WorkApp.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 27.11.20.
//

import SwiftUI
import PartialSheet

@main
struct Time_of_WorkApp: App {
    let persistenceContainer = PersistenceController.shared
    let sheetManager: PartialSheetManager = PartialSheetManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
                .environmentObject(ProjectEnvironment())
                .environmentObject(sheetManager)
        }
    }
}
