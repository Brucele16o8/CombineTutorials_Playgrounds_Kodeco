//
//  ReaderViewModel.swift
//  HackerNewsReader
//
//  Created by Tung Le on 30/7/2025.
//

import Foundation

class ReaderViewModel {
  private let api = API()
  private var allStories = [Story]()
  
  var filter = [String]()
  
  var stories: [Story] {
    guard !filter.isEmpty else {
      return allStories
    }
    
    return allStories
      .filter { story -> Bool in
        return filter.reduce(false) { isMatch, keyword in
          return isMatch || story.title.lowercased().contains(keyword.lowercased())
        }
      }
  }
  
  var error: API.Error? = nil
}
