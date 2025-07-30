//
//  FilterKeyword.swift
//  HackerNewsReader
//
//  Created by Tung Le on 30/7/2025.
//

import SwiftUI

struct FilterKeyword: Identifiable, Codable {
  var id: String { value }
  let value: String
}
