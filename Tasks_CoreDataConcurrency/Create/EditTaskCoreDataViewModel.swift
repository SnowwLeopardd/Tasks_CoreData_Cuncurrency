//
//  Untitled.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import Foundation
import CoreData

final class EditTaskCoreDataViewModel: ObservableObject {
    
    @Published var taskCoreData: TaskCoreData
    
    private let context: NSManagedObjectContext

    init(provider: TaskCoreDataProvider, taskCoreData: TaskCoreData? = nil) {
        self.context = provider.newContext
        self.taskCoreData =  TaskCoreData(context: self.context)
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
