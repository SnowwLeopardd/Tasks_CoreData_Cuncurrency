import XCTest
import CoreData
@testable import Tasks_CoreDataConcurrency

final class TaskCoreDataTests: XCTestCase {
    var provider: TaskCoreDataProvider!
    var context: NSManagedObjectContext!

    override func setUp() {
        // Initialize Core Data provider and context
        provider = TaskCoreDataProvider.shared
        context = provider.backroundContext
    }

    override func tearDown() {
        // Clean up
        provider = nil
        context = nil
        
    }

    func testCreateTask() throws {
        // Given
        let initialCount = try context.count(for: TaskCoreData.all())

        // When
        let task = TaskCoreData(context: context)
        task.apiId = 5678
        task.title = "Test Task"
        task.todo = "Test Todo"
        task.date = Date()
        task.userId = 1234

        try provider.save(in: context)

        // Then
        let finalCount = try context.count(for: TaskCoreData.all())
        XCTAssertEqual(finalCount, initialCount + 1, "Task should be successfully created.")
    }

    func testReadTask() throws {
        // Given
        let task = TaskCoreData(context: context)
        task.title = "Read Test"
        task.todo = "Read Test Todo"
        try provider.save(in: context)

        // When
        let request = TaskCoreData.all()
        request.predicate = TaskCoreData.filter("Read Test")
        let results = try context.fetch(request)

        // Then
        XCTAssertEqual(results.count, 1, "Should fetch one task matching the title.")
        XCTAssertEqual(results.first?.title, "Read Test", "Fetched task should match the created task.")
    }

    func testUpdateTask() throws {
        // Given
        let task = TaskCoreData(context: context)
        task.title = "Update Test"
        task.todo = "Update Test Todo"
        try provider.save(in: context)

        // When
        task.title = "Updated Title"
        try provider.save(in: context)

        // Then
        let request = TaskCoreData.all()
        request.predicate = TaskCoreData.filter("Updated Title")
        let results = try context.fetch(request)
        XCTAssertEqual(results.count, 1, "Updated task should be fetchable by new title.")
        XCTAssertEqual(results.first?.title, "Updated Title", "Task title should be updated.")
    }

    func testDeleteTask() throws {
        // Given
        let task = TaskCoreData(context: context)
        task.title = "Delete Test"
        try provider.save(in: context)

        let request = TaskCoreData.all()
        request.predicate = TaskCoreData.filter("Delete Test")
        let tasks = try context.fetch(request)
        XCTAssertFalse(tasks.isEmpty, "Task should exist before deletion.")

        // When
        try provider.delete(task, in: context)

        // Then
        let remainingTasks = try context.fetch(request)
        XCTAssertTrue(remainingTasks.isEmpty, "Task should be deleted.")
    }
}
