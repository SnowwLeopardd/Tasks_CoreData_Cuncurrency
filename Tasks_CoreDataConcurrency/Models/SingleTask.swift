//
//  Untitled.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/23/24.
//

import Foundation

struct SingleTask: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
