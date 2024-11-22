//
//  TaskCoreDataDetailView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct TaskDetailView: View {
    @Binding var path: [TaskCoreData]
    
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var taskCoreData: TaskCoreData
    @ObservedObject var vm: EditTaskCoreDataViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(String(localized: "Header"), text: $taskCoreData.title)
            
            DatePicker(String(localized: "Date"), selection: $taskCoreData.date, displayedComponents: .date)
                .labelsHidden()
            
            TextEditor(text: $taskCoreData.todo)
        }
        .padding(.horizontal, 16)
        .onDisappear {
            saveChanges()
        }
    }
}

private extension TaskDetailView {
    func saveChanges() {
        
        do {
            if moc.hasChanges {
                try moc.save()
            }
        } catch {
            print(error)
        }
    }
}


struct TaskDetailView_Previews: PreviewProvider {
    @State static var mockTasks: [TaskCoreData] = [.preview()]

       static var previews: some View {
           TaskDetailView(path: $mockTasks, taskCoreData: .preview(), vm: .init(provider: TaskCoreDataProvider.shared))
       }
}
