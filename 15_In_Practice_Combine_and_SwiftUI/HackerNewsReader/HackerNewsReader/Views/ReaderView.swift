//
//  ContentView.swift
//  HackerNewsReader
//
//  Created by Tung Le on 30/7/2025.
//

import SwiftUI
import Combine

struct ReaderView: View {
  @ObservedObject var model: ReaderViewModel
  @State private var presentingSettingSheet = false
  @State private var currentDate = Date()
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  @EnvironmentObject var settings: Settings

  
  private let timer = Timer.publish(every: 10, on: .main, in: .common)
    .autoconnect()
    .eraseToAnyPublisher()
    
  var body: some View {
    let filter = settings.keywords.isEmpty
    ? "Showing all stories"
    : "Filter" + ": " + settings.keywords.map{ $0.value }.joined(separator: ", ")
    
    return NavigationStack {
      List {
        Section(header: Text(filter).padding(.leading, -10)) {
          ForEach(model.stories) { story in
            VStack(alignment: .leading, spacing: 10) {
              TimeBadge(time: story.time)
              
              Text(story.title)
                .frame(minHeight: 0, maxHeight: 100)
                .font(.title)
              
              PostedBy(
                time: story.time,
                user: story.by,
                currentDate: self.currentDate
              )
              
              Button(story.url) {
                print(story)
              }
              .font(.subheadline)
              .foregroundColor(colorScheme == .light ? .blue : .orange)
              .padding(.top, 6)
            }
          }
          .onReceive(timer) {
            currentDate = $0
          }
        }
        .padding()
      } /// List
      .listStyle(PlainListStyle())
      .sheet(isPresented: $presentingSettingSheet, content: {
        SettingsView()
      })
      .alert(item: $model.error) { error in
        Alert(
          title: Text("Network error"),
          message: Text(error.localizedDescription),
          dismissButton: .cancel()
        )
      }
      .navigationBarTitle(Text("\(model.stories.count) Stories"))
      .navigationBarItems(trailing: Button("Setting") {
        /// Set presentingSettingsSheet to true here
        presentingSettingSheet = true
      })
    }
  }
}

#Preview {
  ReaderView(model: ReaderViewModel())
    .environmentObject(Settings())
}
