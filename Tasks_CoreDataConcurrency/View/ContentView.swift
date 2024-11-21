//
//  ContentView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingNewSingleTaskCoreData = false
    @FetchRequest(fetchRequest: SingleTaskCoreData.all()) private var tasksCoreData
    
    var provider = SingleTaskCoreDataProvider.shared
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tasksCoreData) { task in
                    TaskRowView(singleTaskCoreData: task, provider: provider)
                    
                    ZStack(alignment: .leading) {
                        NavigationLink(destination: TaskDetailView(singleTaskCoreData: task)) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingNewSingleTaskCoreData.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingNewSingleTaskCoreData) {
                NavigationStack {
                    CreateSingleTaskCoreDataView(vm: .init(provider: provider))
                }
            }
            .navigationTitle(String(localized: "Tasks"))
        }
    }
}
