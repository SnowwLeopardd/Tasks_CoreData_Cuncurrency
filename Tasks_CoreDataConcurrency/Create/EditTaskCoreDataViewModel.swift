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
    private let provider: TaskCoreDataProvider

    init(provider: TaskCoreDataProvider, taskCoreData: TaskCoreData? = nil) {
        self.provider = provider
        self.context = provider.newContext
        
        if let taskCoreData,
           let existingTaskCoreDataCopy = provider.exisits(taskCoreData,
                                                           in: context) {
            self.taskCoreData = existingTaskCoreDataCopy
        } else {
            self.taskCoreData = TaskCoreData(context: self.context)
        }
        
    }
    
    func save() throws {
        try provider.persist(in: context)
    }
}
