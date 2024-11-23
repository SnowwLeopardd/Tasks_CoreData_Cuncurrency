//
//  Untitled 2.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/23/24.
//

import Foundation

struct TasksResponse: Decodable {
    let todos: [SingleTask]
    let total: Int
    let skip: Int
    let limit: Int
}
