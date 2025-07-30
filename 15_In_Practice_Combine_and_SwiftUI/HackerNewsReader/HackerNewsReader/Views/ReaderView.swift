//
//  ContentView.swift
//  HackerNewsReader
//
//  Created by Tung Le on 30/7/2025.
//

import SwiftUI

struct ReaderView: View {
  var model: ReaderViewModel
  var presentingSettingSheet = false
  
  var currentDate = Date()
  
  var body: some View {
    let filter = "Showing all stories"
    
    return NavigationStack {
      List {
        Section(header: Text(filter).padding(.leading, -10)) {
          ForEach(model.stories) { story in
            VStack(alignment: .leading, spacing: 10) {
              
            }
          }
        }
      } /// List
      .listStyle(PlainListStyle())
      // Present the Settings sheet here
      // Display errors here
      .navigationBarTitle(Text("\(model.stories.count) Stories"))
      .navigationBarItems(trailing: Button("Setting") {
        // Set presentingSettingsSheet to true here
      })
    }
  }
}

#Preview {
  ReaderView(model: ReaderViewModel())
}
