//
//  SingleTaskCoreDataDetailView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct TaskDetailView: View {
    
    let singleTaskCoreData: SingleTaskCoreData
    
    var body: some View {
        List {
            
            Section("General") {
                
                LabeledContent {
                    Text(singleTaskCoreData.title)
                } label: {
                    Text("title")
                }
                
            }
        }
    }
}
