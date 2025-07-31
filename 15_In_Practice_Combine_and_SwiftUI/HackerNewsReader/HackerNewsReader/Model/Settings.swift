//
//  Settings.swift
//  HackerNewsReader
//
//  Created by Tung Le on 30/7/2025.
//

import Foundation
import Combine

fileprivate let keywordsFile = "keywordsFile"

final class Settings: ObservableObject {
  init() {
    if let filterKeywords: [FilterKeyword] =  try? JSONFile.loadValue(named: keywordsFile) {
      keywords = filterKeywords
    }
  }
  
  @Published var keywords = [FilterKeyword]() {
    didSet {
      try? JSONFile.save(keywords, named: keywordsFile)
    }
  }
}
