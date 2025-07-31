//
//  ReaderViewModel.swift
//  HackerNewsReader
//
//  Created by Tung Le on 30/7/2025.
//

import Foundation
import Combine

class ReaderViewModel: ObservableObject {
  private let api = API()
  @Published private(set) var allStories = [Story]()
  @Published var error: API.Error? = nil
  @Published var filter = [String]()
  
  private var subscriptions = Set<AnyCancellable>() /// subscriptions
  
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

  
  // MARK: - Methods
  /// ✅
  func fetchStories() {
    api
      .stories()
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            self.error = error
          }
        },
        receiveValue: { stories in
          self.allStories = stories
          self.error = nil
        }
      )
      .store(in: &subscriptions)
  }
} // 🧱
