//
//  TaskCoreDataDetailView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct TaskDetailView: View {
    
    let taskCoreData: TaskCoreData
    
    var body: some View {
        List {
            
            Section("General") {
                
                LabeledContent {
                    Text(taskCoreData.title)
                } label: {
                    Text("title")
                }
                
            }
        }
    }
}
