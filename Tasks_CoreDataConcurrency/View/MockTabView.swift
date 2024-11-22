//
//  MocktabView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct MockTabView: View {
    
    let provider = TaskCoreDataProvider.shared
    
    @FetchRequest(fetchRequest: TaskCoreData.all()) private var tasksCoreData
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(String(localized: "\(tasksCoreData.count)_tasks"))
                .foregroundColor(.white)
            
            Spacer()
            
            NavigationLink(destination: CreateTaskCoreDataView(vm: .init(provider: provider))) {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.yellow)
            }
        }
        .padding()
        .background(Color(.gray))
    }
}

//struct MockTabView_Previews: PreviewProvider {
//   static var previews: some View {
//       let preview = TaskCoreDataProvider.shared
//       MockTabView(provider: preview)
//   }
//}
