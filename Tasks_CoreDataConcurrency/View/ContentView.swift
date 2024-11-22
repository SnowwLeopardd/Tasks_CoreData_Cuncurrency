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
    @FetchRequest(fetchRequest: TaskCoreData.all()) private var tasksCoreData
    @State private var path = [TaskCoreData]()
    var provider = TaskCoreDataProvider.shared
    @State private var searchConfig: SearchConfig = .init()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(tasksCoreData) { task in
                    TaskRowView(path: $path, taskCoreData: task, provider: provider)
                        .swipeActions(allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                do {
                                    try provider.delete(task, in: provider.newContext)
                                } catch {
                                    print(error)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                            
                            Button {
                                path.append(task)
                            } label: {
                                Label("Edit", systemImage: "pencil")
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
                                    try provider.delete(task, in: provider.newContext)
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
            .navigationDestination(for: TaskCoreData.self, destination: { task in
                TaskDetailView(path: $path, taskCoreData: task, vm: .init(provider: provider,
                                                                          taskCoreData: task))
            })
            
            MockTabView()
        }
    }
}
    
struct ContectView_Previews: PreviewProvider {
    static var previews: some View {
        let preview = TaskCoreDataProvider.shared
        ContentView()
            .environment(\.managedObjectContext, preview.viewContext)
            .onAppear { TaskCoreData.makePreview(count: 7, in: preview.viewContext)
            }
    }
}
