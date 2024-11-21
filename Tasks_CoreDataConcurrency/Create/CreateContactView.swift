//
//  reateSingleTaskCoreDataView.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import SwiftUI

struct CreateSingleTaskCoreDataView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: EditSingleTaskCoreDataViewModel

       var body: some View {
           List {
               
               Section("General") {
                  
                   TextField("Name", text: $vm.singleTaskCoreData.title)
                   
               }
           }
           .navigationTitle("name here")
           .toolbar {
               ToolbarItem(placement: .confirmationAction) {
                   Button("Done") {
                       do {
                           try vm.save()
                       } catch {
                           print(error)
                       }
                       
                       dismiss()
                   }
               }
               
               ToolbarItem(placement: .navigationBarLeading) {
                   Button("Cancel") {
                       dismiss()
                   }
               }
           }
       }
}
