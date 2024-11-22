//
//  ContentView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(fetchRequest: TaskCoreData.all()) private var tasksCoreData
    @State private var path = [TaskCoreData]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(tasksCoreData) { task in
                    TaskRowView(path: $path, taskCoreData: task)
                        .contextMenu {
                            Button {
                                path.append(task)
                            } label: {
                                Label(String(localized: "Edit"), systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                // delete function
                            } label: {
                                Label(String(localized: "Delete"), systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle(String(localized: "Tasks"))
            .navigationDestination(for: TaskCoreData.self, destination: { task in
                TaskDetailView(path: $path, taskCoreData: task)
            })
            
            MockTabView()
        }
    }
}
