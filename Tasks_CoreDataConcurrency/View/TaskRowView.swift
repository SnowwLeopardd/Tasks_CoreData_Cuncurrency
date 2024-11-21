//
//  SingleTaskCoreDataRowView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct TaskRowView: View {
    
    @Environment(\.managedObjectContext) private var moc
    @ObservedObject var singleTaskCoreData: SingleTaskCoreData
    let provider: SingleTaskCoreDataProvider
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                Button {
                    toggleCompleted()
                } label: {
                    Image(systemName: singleTaskCoreData.completed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(singleTaskCoreData.completed ? .yellow : .gray)
                        .padding(.top, 5)
                }
                .buttonStyle(.plain)
                
                VStack(alignment: .leading) {
                    Text(singleTaskCoreData.title)
                        .strikethrough(singleTaskCoreData.completed, color: .gray)
                        .foregroundColor(singleTaskCoreData.completed ? .gray : .black)
                        .font(.headline)
                    
                    Text(singleTaskCoreData.todo)
                        .lineLimit(2)
                        .foregroundColor(singleTaskCoreData.completed ? .gray : .black)
                        .font(.subheadline)
                    
                    Text(DateFormatter.convertDateToString(from: singleTaskCoreData.date))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
//            path.append(task)
        }
    }
}

private extension TaskRowView {
    
    func toggleCompleted() {
        singleTaskCoreData.completed.toggle()
        do {
            if moc.hasChanges {
                try moc.save()
            }
        } catch {
            print(error)
        }
    }
}
