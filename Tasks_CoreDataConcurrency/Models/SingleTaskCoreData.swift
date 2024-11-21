//
//  Untitled.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import Foundation
import CoreData

final class SingleTaskCoreData: NSManagedObject, Identifiable {
    
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

extension SingleTaskCoreData {
    
    private static var singleTasksCoreDataFetchRequest: NSFetchRequest<SingleTaskCoreData> {
        NSFetchRequest(entityName: "SingleTaskCoreData")
    }
    
    static func all() -> NSFetchRequest<SingleTaskCoreData> {
        let request: NSFetchRequest<SingleTaskCoreData> = singleTasksCoreDataFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \SingleTaskCoreData.title, ascending: true)
        ]
        return request
    }
}
