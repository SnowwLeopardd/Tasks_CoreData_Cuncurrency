//
//  Tasks_CoreDataConcurrencyApp.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

@main
struct Tasks_CoreDataConcurrencyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, SingleTaskCoreDataProvider.shared.viewContext)
        }
    }
}
