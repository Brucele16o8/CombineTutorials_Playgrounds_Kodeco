//
//  HackerNewsReaderApp.swift
//  HackerNewsReader
//
//  Created by Tung Le on 30/7/2025.
//

import SwiftUI

@main
struct HackerNewsReaderApp: App {
  let viewmodel = ReaderViewModel()
  
  var body: some Scene {
    WindowGroup {
      ReaderView(model: viewmodel)
    }
  }
}
