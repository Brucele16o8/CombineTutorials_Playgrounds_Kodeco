//
//  JSONFile.swift
//  HackerNewsReader
//
//  Created by Tung Le on 31/7/2025.
//

import Foundation

struct JSONFile {
  private static var documentsDirectory: URL {
    URL.documentsDirectory
  }
  
  /// Load a persisted value from a JSON file
  static func loadValue<T: Codable>(named name: String) throws -> T {
    let fileURL = documentsDirectory.appending(path: "\(name).json")
    let data = try Data(contentsOf: fileURL)
    return try JSONDecoder().decode(T.self, from: data)
  }
  
  /// Persist an object as JSON file
  static func save<T: Codable>(_ value: T, named name: String) throws {
    let fileURL = documentsDirectory.appending(path: "\(name).json")
    let data = try JSONEncoder().encode(value)
    try data.write(to: fileURL, options: .atomic)
  }
}
