//
//  Untitled.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import Foundation
import CoreData

final class TaskCoreData: NSManagedObject, Identifiable {
    
    @NSManaged var apiId: Int64
    @NSManaged var completed: Bool
    @NSManaged var date: Date
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var todo: String
    @NSManaged var userId: Int64
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Int64(1234), forKey: "apiId")
        setPrimitiveValue(true, forKey: "completed")
        setPrimitiveValue(Date.now, forKey: "date")
        setPrimitiveValue(UUID(), forKey: "id")
        setPrimitiveValue("Primitive_title", forKey: "title")
        setPrimitiveValue("Primitive_todo", forKey: "todo")
        setPrimitiveValue(Int64(0987), forKey: "userId")
    }
}

extension TaskCoreData {
    
    private static var tasksCoreDataFetchRequest: NSFetchRequest<TaskCoreData> {
        NSFetchRequest(entityName: "TaskCoreData")
    }
    
    static func all() -> NSFetchRequest<TaskCoreData> {
        let request: NSFetchRequest<TaskCoreData> = tasksCoreDataFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskCoreData.title, ascending: true)
        ]
        return request
    }
}
