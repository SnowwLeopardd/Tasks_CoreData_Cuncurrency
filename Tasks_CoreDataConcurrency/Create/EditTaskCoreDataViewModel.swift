//
//  Untitled.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import Foundation
import CoreData

final class EditTaskCoreDataViewModel: ObservableObject {
    
    // point to entity which user will edit, and trigger update in UI
    @Published var taskCoreData: TaskCoreData
    
    // point to context, in user will edit task
    private let context: NSManagedObjectContext
    
    // point to provider, which will be resposible for CRUD operators.
    private let provider: TaskCoreDataProvider

    init(provider: TaskCoreDataProvider, taskCoreData: TaskCoreData? = nil) {
        self.provider = provider
        
        // The backroundContext from the provider is assigned to context. This ensures that all Core Data operations in this view model happen in a background context, which is thread-safe for background operations.
        self.context = provider.backroundContext
        
        if let taskCoreData,
           let existingTaskCoreDataCopy = provider.exisits(taskCoreData,
                                                           in: context) {
            print("worked 1")
            // we make reference from existing copy of TaskCoreData (which we can see on main screen) to property in this viewModel (EditTaskCoreDataViewModel)
            self.taskCoreData = existingTaskCoreDataCopy
        } else {
            print("worked 2")
            // if taskCoreData doesn't exist in context, we create new taskCoreData in context of EditTaskCoreDataViewModel(which is backgroundContext)
            self.taskCoreData = TaskCoreData(context: self.context)
        }
        
    }
    
    // save changes happened in EditTaskCoreDataViewModel via provider to disc/memory
    func save() throws {
        try provider.save(in: context)
    }
}
