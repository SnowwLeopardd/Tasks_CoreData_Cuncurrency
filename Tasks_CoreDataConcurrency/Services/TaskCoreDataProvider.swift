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
    
    var backroundContext: NSManagedObjectContext {
        print("backgroundContext")
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }
    
    func exisits(_ taskCoreData: TaskCoreData,
                 in context: NSManagedObjectContext) -> TaskCoreData? {
        try? context.existingObject(with: taskCoreData.objectID) as? TaskCoreData
    }
    
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
    
    func save(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TaskCoreData")
        
        // Replaces the persistent store location with a temporary, in-memory database (/dev/null), so data changes don’t persist between previews.
        if EnvironmentValues.isPreview || Thread.current.isRunningXCTest {
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

extension Thread {
    var isRunningXCTest: Bool {
    for key in self.threadDictionary.allKeys {
      guard let keyAsString = key as? String else {
        continue
      }
    
      if keyAsString.split(separator: ".").contains("xctest") {
        return true
      }
    }
    return false
  }
}
