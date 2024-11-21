//
//  Untitled.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import Foundation
import CoreData

final class EditSingleTaskCoreDataViewModel: ObservableObject {
    
    @Published var singleTaskCoreData: SingleTaskCoreData
    
    private let context: NSManagedObjectContext

    init(provider: SingleTaskCoreDataProvider, singleTaskCoreData: SingleTaskCoreData? = nil) {
        self.context = provider.newContext
        self.singleTaskCoreData =  SingleTaskCoreData(context: self.context)
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
