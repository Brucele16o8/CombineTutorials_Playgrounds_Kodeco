//
//  HackerNewsReaderApp.swift
//  HackerNewsReader
//
//  Created by Tung Le on 30/7/2025.
//

import SwiftUI
import Combine

@main
struct HackerNewsReaderApp: App {
  let viewmodel = ReaderViewModel()
  let userSettings = Settings()
  
  private var subscriptions = Set<AnyCancellable>()
  
  init() {
    userSettings.$keywords
      .map {
        $0.map { $0.value }
      }
      .assign(to: \.filter, on: viewmodel)
      .store(in: &subscriptions)
    
  }
  
  var body: some Scene {
    WindowGroup {
      ReaderView(model: viewmodel)
        .environmentObject(userSettings)
        .onAppear {
          viewmodel.fetchStories()
        }
    }
  }
}
