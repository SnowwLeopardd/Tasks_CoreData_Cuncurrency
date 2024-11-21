//
//  SingleTaskCoreDataRowView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct SingleTaskCoreDataRowView: View {
    
    @Environment(\.managedObjectContext) private var moc
    @ObservedObject var singleTaskCoreData: SingleTaskCoreData
    let provider: SingleTaskCoreDataProvider
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 8) {

            Text(singleTaskCoreData.title)
                .font(.callout.bold())

            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .topTrailing) {
            Button {
                toggleFave()
            } label: {
                Image(systemName: "star")
                    .font(.title3)
                    .symbolVariant(.fill)
                    .foregroundColor(singleTaskCoreData.completed ? .yellow : .gray.opacity(0.3))
            }
            .buttonStyle(.plain)
        }
    }
}

private extension SingleTaskCoreDataRowView {
    
    func toggleFave() {
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
