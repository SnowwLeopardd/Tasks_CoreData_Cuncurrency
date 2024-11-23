//
//  Untitled.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/23/24.
//

protocol NetworkManagerProtocol {
    func fetchMockTasksResponse() async throws -> TasksResponse
}
