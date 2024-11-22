//
//  createTaskCoreDataView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct CreateTaskCoreDataView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: EditTaskCoreDataViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(String(localized: "Add_task"))
                    .font(.headline)
                    .lineSpacing(22)
                    .foregroundColor(.black)
            }
            .padding(.top, 20)
            .padding(.bottom, 22)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(String(localized:"Enter_title_of_the_task"))
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                
                TextField(String(localized:"super_important_title"), text: $vm.taskCoreData.title)
                    .focused($isFocused)
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color(.black))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.black), lineWidth: 2))
            }
            .padding(.bottom, 22)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(String(localized:"Enter_your_task"))
                    .font(.subheadline)
                    .foregroundColor(.black)
                
                TextField(String(localized:"Description_of_the_task"), text: $vm.taskCoreData.todo)
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color(.black))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.black), lineWidth: 2))
            }
            
            Spacer()
            
            Button(action: {
                do {
                    try vm.save()
                } catch {
                    print(error)
                }
                
                dismiss()
            }) {
                Text(String(localized:"Add_task"))
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.horizontal, 64)
                    .background(.black)
                    .cornerRadius(8)
            }
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 30)
        .onAppear {
            isFocused = true
        }
    }
}

struct CreateTaskCoreDataView_Previews: PreviewProvider {
   static var previews: some View {
       let preview = TaskCoreDataProvider.shared
       
       CreateTaskCoreDataView(vm: .init(provider: preview))
           .environment(\.managedObjectContext, preview.viewContext)
   }
}
