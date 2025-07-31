//
//  SettingsView.swift
//  HackerNewsReader
//
//  Created by Tung Le on 31/7/2025.
//

import SwiftUI

fileprivate struct SettingsBarItems: View {
  let add: () -> Void
  var body: some View {
    HStack {
      Button(action: add) {
        Image(systemName: "plus")
      }
      EditButton()
    }
  }
}

/// A settings view showing a list of filter keywrods.
struct SettingsView: View {
  @EnvironmentObject var settings: Settings
  @State var presentingAddKeywordSheet = false
  
  var body: some View {
    NavigationStack {
      List {
        Section(header: Text("Filter keywords")) {
          ForEach(settings.keywords) { keyword in
            HStack(alignment: .top) {
              Image(systemName: "star")
                .resizable()
                .frame(width: 24, height: 24)
                .scaleEffect(0.67)
                .background(Color.yellow)
                .cornerRadius(5)
              Text(keyword.value)
            }
          }
          .onMove(perform: moveKeyword)
          .onDelete(perform: deleteKeyword)
        }
      } /// List
      .sheet(isPresented: $presentingAddKeywordSheet) {
        AddKeywordView(completed: { newKeyword in
          let new = FilterKeyword(value: newKeyword.lowercased())
          self.settings.keywords.append(new)
          self.presentingAddKeywordSheet = false
        })
        .frame(minHeight: 0, maxHeight: 400, alignment: .center)
      }
      .navigationBarTitle(Text("Settings"))
      .navigationBarItems(trailing: SettingsBarItems(add: addKeyword)) // Plus +
    } /// Navigation Stack
  }
  
  // MARK: - Helper methods
  private func addKeyword() {
    presentingAddKeywordSheet = true
  }
  
  private func moveKeyword(from source: IndexSet, to destination: Int) {
    settings.keywords.move(fromOffsets: source, toOffset: destination)
  }
  
  private func deleteKeyword(at index: IndexSet) {
    settings.keywords.remove(atOffsets: index)
  }
} // 🧱


#Preview {
  SettingsView(
    
  )
  .environmentObject(Settings())
}
