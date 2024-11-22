//
//  TaskCoreDataProvider.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import Foundation
import CoreData
import SwiftUI

final class TaskCoreDataProvider {
    
    static let shared = TaskCoreDataProvider()
    
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        print("viewContext")
        return persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        print("backgroundContext")
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "TaskCoreData")
        //Replaces the persistent store location with a temporary, in-memory database (/dev/null), so data changes don’t persist between previews.
        if EnvironmentValues.isPreview {
            persistentContainer.persistentStoreDescriptions.first?.url = .init(fileURLWithPath: "/dev/null")
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
    }
    
    func exisits(_ taskCoreData: TaskCoreData,
                 in context: NSManagedObjectContext) -> TaskCoreData? {
        try? context.existingObject(with: taskCoreData.objectID) as? TaskCoreData
    }
    
    func delete(_ taskCoreData: TaskCoreData,
                in context: NSManagedObjectContext) throws {
        if let existingTaskCoreData = exisits(taskCoreData, in: context) {
            context.delete(existingTaskCoreData)
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }
    
    func persist(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

extension EnvironmentValues {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
