//
//  ContentView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct SearchConfig: Equatable {
    var query: String = ""
}

struct ContentView: View {
    @State private var searchConfig: SearchConfig = .init()
    @FetchRequest(fetchRequest: TaskCoreData.all()) private var tasksCoreData
    @State private var path = [TaskCoreData]()
    var provider = TaskCoreDataProvider.shared
    
    @ObservedObject var editTaskCoreDataViewModel: EditTaskCoreDataViewModel
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(tasksCoreData) { task in
                    TaskRowView(path: $path, taskCoreData: task, provider: provider)
                        .swipeActions(allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                do {
                                    try provider.delete(task, in: provider.backroundContext)
                                } catch {
                                    print(error)
                                }
                            } label: {
                                Label(String(localized: "Delete"), systemImage: "trash")
                            }
                            .tint(.red)
                            
                            Button {
                                path.append(task)
                            } label: {
                                Label(String(localized: "Edit"), systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                        .contextMenu {
                            Button {
                                path.append(task)
                            } label: {
                                Label(String(localized: "Edit"), systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                do {
                                    try provider.delete(task, in: provider.backroundContext)
                                } catch {
                                    print(error)
                                }
                            } label: {
                                Label(String(localized: "Delete"), systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle(String(localized: "Tasks"))
            .searchable(text: $searchConfig.query)
            .onChange(of: searchConfig) { _ , newValue in
                tasksCoreData.nsPredicate = TaskCoreData.filter(newValue.query)
            }
            .onAppear {
                Task {
                    await createInitialData()
                }
            }
            .navigationDestination(for: TaskCoreData.self, destination: { task in
                TaskDetailView(path: $path, taskCoreData: task, editTaskCoreDataViewModel: .init(provider: provider, taskCoreData: task))
            })
            
            MockTabView()
        }
    }
    
    private func createInitialData() async {
        if tasksCoreData.isEmpty {
            do {
                let taskResponse = try await networkManager.fetchMockTasksResponse()
                
                for task in taskResponse.todos {
                    // Create a new instance of EditTaskCoreDataViewModel for each task
                    let editTaskVM = EditTaskCoreDataViewModel(provider: provider)
                    
                    do {
                        editTaskVM.taskCoreData.apiId = Int64(task.id)
                        editTaskVM.taskCoreData.id = UUID()
                        editTaskVM.taskCoreData.completed = task.completed
                        editTaskVM.taskCoreData.todo = task.todo
                        editTaskVM.taskCoreData.userId = Int64(task.userId)
                        editTaskVM.taskCoreData.title = String(localized: "JSON_doesn't_contain_title")
                        editTaskVM.taskCoreData.date = .distantFuture
                        
                        try editTaskVM.save()
                    } catch {
                        print("Error saving task \(task.id): \(error)")
                    }
                }
            } catch {
                print("Error fetching tasks: \(error.localizedDescription)")
            }
        }
    }
}
    
struct ContectView_Previews: PreviewProvider {
    static var previews: some View {
        let preview = TaskCoreDataProvider.shared
        ContentView( editTaskCoreDataViewModel: .init(provider: preview))
            .environment(\.managedObjectContext, preview.viewContext)
            .onAppear { TaskCoreData.makePreview(count: 7, in: preview.viewContext)
            }
    }
}
