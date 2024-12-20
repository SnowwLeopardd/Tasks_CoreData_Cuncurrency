//
//  TaskCoreDataRowView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct TaskRowView: View {
    @Binding var path: [TaskCoreData]
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var taskCoreData: TaskCoreData
    
    let provider: TaskCoreDataProvider
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                Button {
                    toggleCompleted()
                } label: {
                    Image(systemName: taskCoreData.completed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(taskCoreData.completed ? .yellow : .gray)
                        .padding(.top, 5)
                }
                .buttonStyle(.plain)
                
                VStack(alignment: .leading) {
                    Text(taskCoreData.title)
                        .strikethrough(taskCoreData.completed, color: .gray)
                        .foregroundColor(taskCoreData.completed ? .gray : .white)
                        .font(.headline)
                    
                    Text(taskCoreData.todo)
                        .lineLimit(2)
                        .foregroundColor(taskCoreData.completed ? .gray : .white)
                        .font(.subheadline)
                    
                    
                    Text(DateFormatter.convertDateToString(from: taskCoreData.date))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(taskCoreData)
        }
    }
}

private extension TaskRowView {
    func toggleCompleted() {
        taskCoreData.completed.toggle()
        
        do {
            try provider.save(in: viewContext)
        } catch {
            print(error)
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    @State static var mockTasks: [TaskCoreData] = [.preview()]
    
       static var previews: some View {
           let previewProvider = TaskCoreDataProvider.shared
           TaskRowView(path: $mockTasks, taskCoreData: .preview(context: previewProvider.viewContext), provider: previewProvider)
       }
}
