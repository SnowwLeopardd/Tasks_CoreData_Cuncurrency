//
//  ContentView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingNewTaskCoreData = false
    @FetchRequest(fetchRequest: TaskCoreData.all()) private var tasksCoreData
    
    var provider = TaskCoreDataProvider.shared
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tasksCoreData) { task in
                    TaskRowView(taskCoreData: task, provider: provider)
                    
                    ZStack(alignment: .leading) {
                        NavigationLink(destination: TaskDetailView(taskCoreData: task)) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingNewTaskCoreData.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingNewTaskCoreData) {
                NavigationStack {
                    CreateTaskCoreDataView(vm: .init(provider: provider))
                }
            }
            .navigationTitle(String(localized: "Tasks"))
        }
    }
}
