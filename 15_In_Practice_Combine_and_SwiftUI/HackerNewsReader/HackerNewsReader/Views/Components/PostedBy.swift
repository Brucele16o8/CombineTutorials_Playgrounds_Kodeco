//
//  PostedBy.swift
//  HackerNewsReader
//
//  Created by Tung Le on 31/7/2025.
//

import SwiftUI

struct PostedBy: View {
  let time: TimeInterval
  let user: String
  let currentDate: Date
  
  private static let relativeDateFormatter = RelativeDateTimeFormatter()
  
  private var relativeTimeString: String {
    return PostedBy.relativeDateFormatter.localizedString(fromTimeInterval: time - currentDate.timeIntervalSince1970)
  }
  
  var body: some View {
    Text("\(relativeTimeString) by \(user)")
      .font(.headline)
      .foregroundColor(Color.gray)
  }
}


#Preview {
  PostedBy(
    time: Date().addingTimeInterval(-300).timeIntervalSince1970,
    user: "Luke",
    currentDate: Date()
  )
}
