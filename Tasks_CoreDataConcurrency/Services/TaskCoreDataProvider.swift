//
//  TaskCoreDataProvider.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import Foundation
import CoreData
import SwiftUI

// Step 3.
final class TaskCoreDataProvider {
    
    // Create a singletone, so one instance existed across the app.
    static let shared = TaskCoreDataProvider()
    
    // Create persistentContainer.
    private let persistentContainer: NSPersistentContainer
    
    // Create viewContext.
    var viewContext: NSManagedObjectContext {
        print("viewContext")
        return persistentContainer.viewContext
    }
    
    // Manually create backroundContext.
    var backroundContext: NSManagedObjectContext {
        print("backgroundContext")
        // defain backgroundStyle of context
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        // Assosiate backgroundContext with the persistentStoreCoordinator, which already assosiated with viewContext.
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }
    
    // support function, to find if task exist in context
    func exisits(_ taskCoreData: TaskCoreData,
                 in context: NSManagedObjectContext) -> TaskCoreData? {
        try? context.existingObject(with: taskCoreData.objectID) as? TaskCoreData
    }
    
    // delete task from context
    func delete(_ taskCoreData: TaskCoreData,
                in context: NSManagedObjectContext) throws {
        if let existingTaskCoreData = exisits(taskCoreData, in: context) {
            context.delete(existingTaskCoreData)
            // ensuring thread safety, if we decide to delete from viewContext
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }
    
    // save changes in context
    func save(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }

    private init() {
        // Create persistentContainer based on xcdatamodeld.
        persistentContainer = NSPersistentContainer(name: "TaskCoreData")
        
        //Replaces the persistent store location with a temporary, in-memory database (/dev/null), so data changes don’t persist between previews.
        if EnvironmentValues.isPreview {
            persistentContainer.persistentStoreDescriptions.first?.url = .init(fileURLWithPath: "/dev/null")
        }
        
        // automatically merge changes from backgroundContext to viewContext
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        // Loads the persistent stores (SQLite database or in-memory store) for the persistentContainer.
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
    }
}

// check whether app in running in SwiftUI preview mode
extension EnvironmentValues {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
